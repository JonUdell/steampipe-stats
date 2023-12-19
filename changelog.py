import argparse, os, re, requests, sys
import pandas as pd
import plotly.graph_objects as go
import mpld3
from datetime import datetime, timedelta
from enum import Enum

IS_TEST_MODE = False
IS_NEW_MODE = False
DATAFILE = 'data.csv'

plugin_mod_pattern = r'<div class="pr-2 col-auto"><span class="text-monospace">(.+?)<!-- -->(/?)<!-- -->(.+?)</span></div>'

def read_data(filename):
    # Read the data from the CSV file, which is an export of the members_join_commits table
    df = pd.read_csv(filename)
    
    # Convert the html_url values to links in the full table
    df['html_url'] = df['html_url'].apply(lambda x: f'<a href="{x}" target="_blank">Link</a>')
    
    return df

def get_repos_from_url(url, subpattern):
    response = requests.get(url)
    content = response.text
    matches = re.findall(plugin_mod_pattern, content)

    all_results = [
        match[0] + "/" + subpattern + "-" + match[2].replace("_", "-")
        for match in matches
    ]

    turbot_results = [x for x in all_results if x.startswith('turbot')]
    external_results = [x for x in all_results if not x.startswith('turbot')]

    return (all_results, turbot_results, external_results)

def get_plugin_repos():
    return get_repos_from_url("https://hub.steampipe.io/plugins", "steampipe-plugin")

def get_mod_repos():
    return get_repos_from_url("https://hub.steampipe.io/mods", "steampipe-mod")

class PluginOrModType(Enum):
    ALL = 0
    TURBOT = 1 
    NON_TURBOT = 2

def count_plugins(plugin_or_mod_type):
    p = get_plugin_repos()
    return len(p[plugin_or_mod_type.value])

def count_mods(plugin_or_mod_type):
    p = get_mod_repos()
    return len(p[plugin_or_mod_type.value])

def filter_version_sections(changelog, days):
    """
    Filters the changelog to only include version sections within the last x days.

    Parameters:
    - changelog (str): The full changelog text
    - days (int): Number of days back to include

    Returns:
    - str: Changelog filtered to the specified date range
    """

    # Extract version sections
    version_sections = extract_version_sections(changelog)

    # Get cutoff date
    cutoff = get_reference_date() - timedelta(days=days)

    # Filter sections after cutoff date
    filtered = []
    for ver, section in version_sections:
        date_match = re.search(r"\[(\d{4}-\d{2}-\d{2})\]", section)
        if date_match:
            section_date = datetime.strptime(date_match.group(1), "%Y-%m-%d")
            if section_date >= cutoff:
                filtered.append(section)

    # Reconstruct changelog
    return "## " + "## ".join(filtered)

def extract_version_sections(changelog):
    """
    Extracts version sections from a changelog.

    Parameters:
    - changelog (str): The changelog text.

    Returns:
    - list of tuples: Each tuple contains a version string and the corresponding section content.
    """
    # Split the changelog into separate version sections using "## " as a delimiter
    versions = changelog.split("## ")[1:]

    version_sections = []
    for version in versions:
        # Search for version number including the 'v' prefix
        match = re.search(r"^(v\d+\.\d+\.\d+)", version)
        if match:
            ver = match.group(1)
            version_sections.append((ver, version))

    return version_sections

def extract_entries_from_section(section_text):
    entry_pattern = r"-\s[^\n]*(?:\n(?!\s*-).*)*"
    entries = re.findall(entry_pattern, section_text, re.MULTILINE)
    return entries

def extract_section_dates(changelog):
    version_sections = extract_version_sections(changelog)
    section_dates = {}
    
    for ver, section in version_sections:
        date_match = re.search(r"\[(\d{4}-\d{2}-\d{2})\]", section)
        if date_match:
            section_date = datetime.strptime(date_match.group(1), "%Y-%m-%d").date()
            section_dates[ver] = section_date
            
    return section_dates

def count_changelog_sections(changelog, section_name):
    section_counts = {}
    version_sections = extract_version_sections(changelog)

    # Define the regex pattern for subsections
    sub_section_pattern = (
        rf"{re.escape(section_name)}\s*\n((?:-\s[^\n]*(?:\n(?!\s*-).*)*\n)+)"
    )

    for ver, section in version_sections:
        # Search for the specified section
        sub_section = re.search(sub_section_pattern, section, re.MULTILINE)
        if sub_section:
            section_text = sub_section.group(1).strip()
            entries = extract_entries_from_section(section_text)
            count = len(entries)
            section_counts[ver] = count
        else:
            section_counts[ver] = 0

    return section_counts

def extract_contributors(changelog):
    contributors = {}
    version_sections = extract_version_sections(changelog)
    for ver, section in version_sections:
        names = re.findall(
            r"Thanks(?: to)? \[@(.+?)\]\(https://github\.com/", section, re.DOTALL
        )
        names = [name.replace("\n", "") for name in names]
        contributors[ver] = names
    return contributors

def count_tables(changelog):
    table_counts = {}
    version_sections = extract_version_sections(changelog)

    for ver, section in version_sections:
        # Search for the pattern "- New tables added" and count the number of new tables mentioned after this pattern
        # Using the regexes we know work from before
        sub_section = re.search(
            r"-.*\btables\b.*\s*\n((?:\s*-\s[^\n]*\n)+)",
            section,
            re.MULTILINE | re.IGNORECASE,
        )
        if sub_section:
            section_text = sub_section.group(1).strip()
            count = len(section_text.split("\n"))
            table_counts[ver] = count
        else:
            table_counts[ver] = 0

    return table_counts

def current_month():
    now = datetime.now()
    formatted_date = now.strftime("%B %Y")
    return formatted_date

def summarize_external_plugins():
    # Base URLs to fetch tags and commits
    tags_url = "https://api.github.com/repos/{}/tags"
    commit_url = "https://api.github.com/repos/{}/git/commits/{}"
    headers = {
        "Authorization": f"token {os.getenv('GITHUB_TOKEN')}",
        "Accept": "application/vnd.github.v3+json"
    }

    # Get external plugins
    non_turbot_plugins = get_plugin_repos()[PluginOrModType.NON_TURBOT.value]
    summary = {}

    for plugin in non_turbot_plugins:
        # Fetch tags for the repo
        response = requests.get(tags_url.format(plugin), headers=headers)
        tags = response.json()
        
        # Find the v0.0.1 tag
        v001_tag = next((tag for tag in tags if tag['name'] == 'v0.0.1'), None)
        if not v001_tag:
            continue
        
        # Fetch its associated commit to get the date
        commit_sha = v001_tag['commit']['sha']
        commit_response = requests.get(commit_url.format(plugin, commit_sha), headers=headers)
        commit_data = commit_response.json()
        
        # Check if 'committer' key exists; if not, use 'author'
        date = commit_data.get('committer', commit_data.get('author', {})).get('date', 'Unknown')
        
        # Store the v0.0.1 tag and its commit date in the summary
        summary[plugin] = {
            "tag": "v0.0.1",
            "commit_date": date
        }

    return summary

def run_tests():
    changelog = """
## v0.115.0 [2023-08-08]

_Enhancements_

- Updated the `Makefile` to build plugin in `STEAMPIPE_INSTALL_DIR` if set. ([#1857](https://github.com/turbot/steampipe-plugin-aws/pull/1857)) (Thanks [@pdecat](https://github.com/pdecat) for the contribution!)
- Added column `offering_class` to `aws_pricing_product` table ([#1863](https://github.com/turbot/steampipe-plugin-aws/pull/1863)) (Thanks [@rasta-rocket](https://github.com/rasta-rocket) for the contribution!)

_Bug fixes_

- Fixed the `aws_ec2_network_load_balancer` table doc to remove the incorrect security group association example. ([#1869](https://github.com/turbot/steampipe-plugin-aws/pull/1869)) (Thanks [@
tinder-tder](https://github.com/tinder-tder) for the contribution!)
- Fixed `aws_rds_db_cluster`, `aws_rds_db_cluster_snapshot`, `aws_rds_db_instance`, `aws_rds_db_snapshot` tables to correctly filter out the `DocDB` and `Neptune` resources. ([#1868](https://github.com/turbot/steampipe-plugin-aws/pull/1868))

## v0.114.0 [2023-08-04]

_What's new?_

- New tables added
  - [aws_neptune_db_cluster_snapshot](https://hub.steampipe.io/plugins/turbot/aws/tables/aws_neptune_db_cluster_snapshot) ([#1866](https://github.com/turbot/steampipe-plugin-aws/pull/1866))

## v0.113.0 [2023-07-28]

_What's new?_

- New tables added
  - [aws_directory_service_log_subscription](https://hub.steampipe.io/plugins/turbot/aws/tables/aws_directory_service_log_subscription) ([#1852](https://github.com/turbot/steampipe-plugin-aws/pull/1852))

_Enhancements_

- Added the `fifo_throughput_limit` and `deduplication_scope` columns to the `aws_sqs_queue` table. ([#1859](https://github.com/turbot/steampipe-plugin-aws/pull/1859)) (Thanks [@pdecat](https://github.com/pdecat) for the contribution!)
- Added the `description` column to the `aws_api_gatewayv2_api` table. ([#1856](https://github.com/turbot/steampipe-plugin-aws/pull/1856)) (Thanks [@pdecat](https://github.com/pdecat) for the contribution!)
"""

    def test_count_tables():
        expected_tables = {"v0.115.0": 0, "v0.114.0": 1, "v0.113.0": 1}
        actual_tables = count_tables(changelog)
        assert actual_tables == expected_tables, f"Expected {expected_tables}, got {actual_tables}"

    def test_count_changelog_sections():
        expected_enhancements = {"v0.115.0": 2, "v0.114.0": 0, "v0.113.0": 2}
        expected_bugfixes = {"v0.115.0": 2, "v0.114.0": 0, "v0.113.0": 0}

        actual_enhancements = count_changelog_sections(changelog, "_Enhancements_")
        actual_bugfixes = count_changelog_sections(changelog, "_Bug fixes_")

        assert actual_enhancements == expected_enhancements, f"Expected {expected_enhancements} enhancements, got {actual_enhancements}"
        assert actual_bugfixes == expected_bugfixes, f"Expected {expected_bugfixes} bugfixes, got {actual_bugfixes}"

    def test_extract_contributors():
        expected_contributors = {
            "v0.115.0": ["pdecat", "rasta-rocket", "tinder-tder"],
            "v0.114.0": [],
            "v0.113.0": ["pdecat", "pdecat"],
        }
        actual_contributors = extract_contributors(changelog)
        assert expected_contributors == actual_contributors, f"Expected {expected_contributors}, got {actual_contributors}"

    def test_extract_section_dates():
        changelog = """
        ## v0.115.0 [2023-08-08]
        ## v0.114.0 [2023-08-04]
        ## v0.113.0 [2023-07-28]
        """
        expected_dates = {
            'v0.115.0': datetime(2023, 8, 8).date(), 
            'v0.114.0': datetime(2023, 8, 4).date(), 
            'v0.113.0': datetime(2023, 7, 28).date()
        }
        actual_dates = extract_section_dates(changelog)
        assert actual_dates == expected_dates, f"Expected {expected_dates}, but got {actual_dates}"

    def test_filter_version_sections():
        expected = """## v0.115.0 [2023-08-08]

_Enhancements_

- Updated the `Makefile` to build plugin in `STEAMPIPE_INSTALL_DIR` if set. ([#1857](https://github.com/turbot/steampipe-plugin-aws/pull/1857)) (Thanks [@pdecat](https://github.com/pdecat) for the contribution!)
- Added column `offering_class` to `aws_pricing_product` table ([#1863](https://github.com/turbot/steampipe-plugin-aws/pull/1863)) (Thanks [@rasta-rocket](https://github.com/rasta-rocket) for the contribution!)

_Bug fixes_

- Fixed the `aws_ec2_network_load_balancer` table doc to remove the incorrect security group association example. ([#1869](https://github.com/turbot/steampipe-plugin-aws/pull/1869)) (Thanks [@
tinder-tder](https://github.com/tinder-tder) for the contribution!)
- Fixed `aws_rds_db_cluster`, `aws_rds_db_cluster_snapshot`, `aws_rds_db_instance`, `aws_rds_db_snapshot` tables to correctly filter out the `DocDB` and `Neptune` resources. ([#1868](https://github.com/turbot/steampipe-plugin-aws/pull/1868))

## v0.114.0 [2023-08-04]

_What's new?_

- New tables added
  - [aws_neptune_db_cluster_snapshot](https://hub.steampipe.io/plugins/turbot/aws/tables/aws_neptune_db_cluster_snapshot) ([#1866](https://github.com/turbot/steampipe-plugin-aws/pull/1866))

"""
        actual = filter_version_sections(changelog, days=15)
        assert actual == expected

    test_count_changelog_sections()
    test_count_tables()
    test_extract_contributors()
    test_extract_section_dates()
    test_filter_version_sections()

def get_changelog(repo):
    url = "https://raw.githubusercontent.com/" + repo + "/main/CHANGELOG.md"
    response = requests.get(url)
    if response.status_code != 200:
        url = "https://raw.githubusercontent.com/" + repo + "/master/CHANGELOG.md"
        response = requests.get(url)
        if response.status_code != 200:
            return ''
    return response.text

def summarize_turbot_plugins(days, new_only, activity_only):
    repos = get_plugin_repos()[PluginOrModType.TURBOT.value]
    results = {}
    for repo in repos:
        results[repo] = {
            'tables': None,
            'enhancements': None,
            'bugfixes': None,
            'contributors': None,
            'is_new': False,
            'section_dates': None
        }

    for repo in repos:
        changelog = get_changelog(repo)
        if changelog == '':
            continue
        
        filtered_changelog = filter_version_sections(changelog, days)
        results[repo]['tables'] = count_tables(filtered_changelog)
        results[repo]['enhancements'] = count_changelog_sections(filtered_changelog,'_Enhancements_')
        results[repo]['bugfixes'] = count_changelog_sections(filtered_changelog,'_Bug fixes_')
        results[repo]['contributors'] = extract_contributors(filtered_changelog)
        results[repo]['is_new'] = is_new(filtered_changelog)
        results[repo]['section_dates'] = extract_section_dates(filtered_changelog)
    
    if new_only:
        results = {k:v for k,v in results.items() if v['is_new']}
    if activity_only:
        results = {k:v for k,v in results.items() if has_activity(v)}
        
    return results

def is_new(filtered_sections):
    return "v0.0.1" in filtered_sections

def has_activity(result):
    if result['tables'] is None: # No changelog data within specified date range
        return False
    
    for table_count in result['tables'].values():
        if table_count > 0:
            return True

    for enhancement_count in result['enhancements'].values():
        if enhancement_count > 0:
            return True

    for bugfix_count in result['bugfixes'].values():
        if bugfix_count > 0:
            return True
    
    return False

def get_reference_date():
    if IS_TEST_MODE:
        return datetime(2023, 8, 18)
    else:
        return datetime.today()

def generate_html(data, days):
    # Initialize grand totals
    grand_total_plugins = 0
    grand_total_tables = 0
    grand_total_enhancements = 0
    grand_total_bugfixes = 0
    grand_total_releases = 0
    all_contributors = set()  # Initialize a set to store all unique contributors

    title = "Steampipe: State of the Union"

    def generate_bar_chart():
        df = read_data(DATAFILE)
        
        # Extract month and count contributions by month
        df['month'] = pd.to_datetime(df['author_date']).dt.to_period('M')
        monthly_counts = df['month'].value_counts().sort_index()

        # Create the bar chart
        fig = go.Figure(data=[
            go.Bar(
                x=monthly_counts.index.strftime('%Y-%m').tolist(),
                y=monthly_counts.values,
                marker_color='skyblue'
            )
        ])

        # Set title, labels, and adjust x-axis properties
        fig.update_layout(
            title="Monthly Contributions",
            xaxis_title="Month",
            yaxis_title="Contributions",
            template="plotly_white",  # Use a white background template
            xaxis=dict(
                tickvals=monthly_counts.index.strftime('%Y-%m').tolist(),  # Set tick positions
                ticktext=monthly_counts.index.strftime('%Y-%m').tolist(),   # Set tick labels
                tickfont=dict(size=10),  # Reduce font size
                tickangle=-45  # Rotate counterclockwise
            ),
            bargap=0.15,  # Slight reduction in the gap between bars
            width=1000  # Increase the width of the plot
        )

        # Convert the figure to HTML without the mode bar
        html_fig = fig.to_html(full_html=False, include_plotlyjs='cdn', config={'displayModeBar': False})

        return html_fig


    def generate_plugin_section(plugin_name, plugin_data):
        nonlocal grand_total_releases
        section_html = f"""<details class="plugin-details"><summary>{plugin_name}"""
        if plugin_data['is_new']:
            section_html += " (new)</span>"
        section_html += "</summary>"
        section_html += generate_summary_table(plugin_data)
        contributors = plugin_data['contributors']
        if contributors and any(len(c) > 0 for c in contributors.values()):
            section_html += "<h3>Contributors</h3>"
            section_html += generate_contributors_table_for_plugin(plugin_data)
            
        return section_html + '</details>'
    
    def generate_summary_table(plugin_data):
        nonlocal grand_total_tables, grand_total_enhancements, grand_total_bugfixes, grand_total_releases
        summary_html = "<table><tr><th>Version</th><th>Date</th><th>New Tables</th><th>Enhancements</th><th>Bugfixes</th></tr>"
        total_tables, total_enhancements, total_bugfixes = 0, 0, 0
        if plugin_data['section_dates'] is None:
            return ''
        for version, date in plugin_data['section_dates'].items():
            grand_total_releases += 1
            tables = plugin_data['tables'].get(version, 0)
            enhancements = plugin_data['enhancements'].get(version, 0)
            bugfixes = plugin_data['bugfixes'].get(version, 0)
            total_tables += tables
            total_enhancements += enhancements
            total_bugfixes += bugfixes
            summary_html += f"<tr><td>{version}</td><td>{date}</td><td>{tables}</td><td>{enhancements}</td><td>{bugfixes}</td></tr>"
        
        summary_html += f"<tr><th>Total</th><th></th><th>{total_tables}</th><th>{total_enhancements}</th><th>{total_bugfixes}</th></tr>"
        summary_html += "</table>"
        
        grand_total_tables += total_tables
        grand_total_enhancements += total_enhancements
        grand_total_bugfixes += total_bugfixes
        
        return summary_html
    
    def generate_contributors_table_for_plugin(plugin_data):
        nonlocal all_contributors
        contributors_html = "<table><tr><th>Version</th><th>Contributors</th></tr>"
        for version, contributors in plugin_data['contributors'].items():
            if contributors:
                contributors_str = ', '.join(contributors)
                contributors_html += f"<tr><td>{version}</td><td>{contributors_str}</td></tr>"
                all_contributors.update(contributors)  # Add contributors to the global set
        contributors_html += "</table>"
        return contributors_html
   
    def get_repos_for_contributors(df):
        return df.groupby('author_login').agg({'repository_full_name': 'unique'}).reset_index().rename(columns={'author_login': 'Contributor'})

    def generate_contributor_table(days=None):
        df = read_data(DATAFILE)

        # If days argument is provided, filter the dataframe
        if days:
            cutoff_date = pd.to_datetime("today") - pd.Timedelta(days=days)
            df = df[df['author_date'] > cutoff_date.strftime('%Y-%m-%d')]
        
        contributor_repos = get_repos_for_contributors(df)
        contributor_counts = df['author_login'].value_counts().reset_index()
        
        # Sort names case-insensitively
        contributor_counts = contributor_counts.sort_values(by='author_login', key=lambda col: col.str.lower())
        
        contributor_counts.columns = ['Contributor', 'Count']
        contributor_counts = contributor_counts.merge(contributor_repos, on='Contributor')
        contributor_counts['Repos'] = contributor_counts['repository_full_name'].apply(lambda x: ', '.join(sorted(x)))
        
        return contributor_counts[['Contributor', 'Count', 'Repos']].to_html(classes="table table-striped", index=False, table_id="contributor_counts")

    def generate_external_plugins_table(days):
        
        def add_checkmark_within_days(df):
            checkmark = '✅'
            
            # Calculate the date range
            today = datetime.today()
            start_date = today - timedelta(days=days)
            end_date = today + timedelta(days=days)
            df['New'] = df['Initial Release Date'].apply(lambda x: checkmark if start_date <= x <= end_date else '')
            return df
        external_plugin_data = summarize_external_plugins()
        # Convert sorted_external_plugins into a dataframe
        sorted_external_plugins = sorted(external_plugin_data.items(), key=lambda x: x[1]['commit_date'], reverse=True)
        df_plugins = pd.DataFrame(sorted_external_plugins, columns=['Plugin', 'Data'])
        df_plugins['Initial Release Date'] = df_plugins['Data'].apply(lambda x: datetime.strptime(x['commit_date'], "%Y-%m-%dT%H:%M:%SZ"))
        filtered_plugins_df = add_checkmark_within_days(df_plugins)

        plugins_html = "<table><tr><th>Plugin</th><th>Initial Release Date (v0.0.1)</th><th>New</th></tr>"
        for _, row in filtered_plugins_df.iterrows():
            formatted_date = row['Initial Release Date'].strftime('%Y-%m-%d')
            is_new = row['New']
            plugins_html += f"<tr><td>{row['Plugin']}</td><td>{formatted_date}</td><td>{is_new}</td></tr>"
        plugins_html += "</table>"
        return plugins_html

    def generate_all_contributions_table():
        df = read_data(DATAFILE)
        return df.to_html(classes="table table-striped", index=False, escape=False, table_id="full_table", 
                      render_links=True, formatters={'message': lambda x: f'<div style="max-width: 200px; word-wrap: break-word;">{x}</div>'})
    
    head = f"""
    <head>
        <meta charset="UTF-8">
        <title>{title}</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin-top: 2em; margin-left: 2em }}
            table {{ width: 100%; margin-top: 1em; margin-bottom: 40px; border-collapse: collapse; }}
            th, td {{ border: 1px solid #cccccc; padding: 8px; text-align: left; font-weight: normal; font-size: 12pt }}
            th {{ background-color: #f2f2f2; }}
            tr:hover {{ background-color: #f5f5f5; }}
            details {{ margin-top: 1em; }}
            details.plugin-details {{ margin-left: 2em}}
        </style>
    </head>
    """
    
    plugin_sections = ''
    for plugin_name, plugin_data in data.items():
        grand_total_plugins += 1
        plugin_sections += generate_plugin_section(plugin_name, plugin_data)
    
    # Generate sorted list of unique contributors
    sorted_unique_contributors = ', '.join(sorted(all_contributors, key=str.casefold))
 
    summary = f"""
    <table>
    <tr>
    <th>Plugins</th>
    <th>Releases</th>
    <th>New Tables</th>
    <th>Enhancements</th>
    <th>Bugfixes</th>
    <th>Contributors</th>
    </tr>
    <tr>
    <td>{grand_total_plugins}</td>
    <td>{grand_total_releases}</td>
    <td>{grand_total_tables}</td>
    <td>{grand_total_enhancements}</td>
    <td>{grand_total_bugfixes}</td>
    <td>{sorted_unique_contributors}</td>
    </tr>
    </table>
    """
    
    html = f"""
    <!DOCTYPE html>
    <html lang="en">
        {head}
        <body>
            <h1>{title}</h1>
            <p>
            As of {current_month()} there are {count_plugins(PluginOrModType.ALL)} plugins <a href="https://hub.steampipe.io/plugins">on the hub</a>. Of those, {count_plugins(PluginOrModType.TURBOT)} are at <em>github.com/turbot</em>, and {count_plugins(PluginOrModType.NON_TURBOT)} are hosted elsewhere. 
            There are {count_mods(PluginOrModType.ALL)} mods <a href="https://hub.steampipe.io/plugins">on the hub</a>, currently all hosted at <em>github.com/turbot</em>.
            </p>

            <p>
            Contributions to Turbot-hosted plugins and mods have accelerated over time.
            </p>

            <p>
            {generate_bar_chart()}
            </p>           

            <p>
            Here are the release dates for all non-Turbot hosted plugins, highlighting those that are new in the last {days} days.
            </p>

            <p>{generate_external_plugins_table(days)}</p>
 
            <p>
            Here's a summary of contributions to Turbot-hosted repos over the last {days} days.
            </p>

            <p>
            {generate_contributor_table(days)}
            </p>

            <p>
            Here's a summary of new and updated Turbot-hosted plugins over the last {days} days.
            </p>

            <p>
            {summary}
            </p>

            <p>
            Here's the release-by-release breakdown for Turbot-hosted plugins created or updated over the last {days} days.
            </p>

            <details>
                <summary>Turbot-hosted plugins: releases and contributors</summary>
                    <p>{plugin_sections}</p>
            </details>

            <p>
            And finally, here's a complete list of contributions to the Steampipe project.
            </p>

            <p>
            {generate_all_contributions_table()}
            </p>

        </body>
    </html>
    """
    
    return html

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-t", "--test", action="store_true", help="Run tests")
    parser.add_argument("--count_all_plugins", action="store_true", help="Count all plugins")
    parser.add_argument("--count_turbot_plugins", action="store_true", help="Count Turbot plugins")
    parser.add_argument("--count_non_turbot_plugins", action="store_true", help="Count non-Turbot plugins")
    parser.add_argument("--count_all_mods", action="store_true", help="Count all mods")
    parser.add_argument("-s", "--summarize", action="store_true", help="Summarize all plugins")
    parser.add_argument("-d", "--days", type=int, default=30, help="Number of days to summarize")
    parser.add_argument("-n", "--new_only", action="store_true", help="Only summarize new plugins (mutually exclusive with -a)")
    parser.add_argument("-a", "--activity_only", action="store_true", help="Only summarize plugins with activity (mutually exclusive with -n)")
    parser.add_argument("--html", action="store_true", help="Print HTML summary")

    args = parser.parse_args()

    if args.new_only:
        IS_NEW_MODE = True

    if len(sys.argv) == 1:
        parser.print_help()
        sys.exit(1)
    elif args.new_only and args.activity_only:
        parser.print_help()
        print("\nYou're using --new_only and --activity_only, please use one or the other.")
    elif args.test:
        IS_TEST_MODE = True
        run_tests()
    elif args.count_all_plugins:
        print(count_plugins(PluginOrModType.ALL))
    elif args.count_turbot_plugins:
        print(count_plugins(PluginOrModType.TURBOT))
    elif args.count_non_turbot_plugins:
        print(count_plugins(PluginOrModType.NON_TURBOT))
    elif args.count_all_mods:
        print(count_mods(PluginOrModType.ALL))
    elif args.summarize:
        print(summarize_turbot_plugins(args.days, args.new_only, args.activity_only))
    elif args.html:
        print(generate_html(summarize_turbot_plugins(args.days, args.new_only, args.activity_only), args.days))

