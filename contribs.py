import json, psycopg2, psycopg2.extras, os, re
conn_str = f"host='localhost' dbname='steampipe' user='steampipe' port='9193' password='{os.getenv('STEAMPIPE_LOCAL_PASSWORD')}'"

def get_repos():
  sql = f"""
    select 
      full_name
    from
      github_my_repository
    where
      full_name = 'turbot/steampipe'
      or full_name ~ 'turbot/steampipe-(mod|plugin)'
    order by
      full_name
  """
  print(sql)
  r = sql_read(sql)
  return r

def sql_read(sql):
  conn = psycopg2.connect(conn_str)
  try:
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)    
    cur.execute(sql)
    r = cur.fetchall()
    cur.close()
  except(Exception, psycopg2.DatabaseError) as error:
    print(error)
  finally:
    conn.close()
  return r

def sql_write(sql):
  conn = psycopg2.connect(conn_str)
  try:
    cur = conn.cursor()
    cur.execute(sql)
    cur.close()
    conn.commit()
  except(Exception, psycopg2.DatabaseError) as error:
    print(error)
  finally:
    conn.close()

def create_org_members_table(org):
  sql = f"""
    create table {org}_members as 
      select
        jsonb_array_elements_text(g.member_logins) as member_login
      from
        github_organization g
      where
        login = '{org}'
  """
  print(sql)
  sql_write(sql)
  
def create_commits_table_for_repo(repo_record):
  table_name = table_name_from_repo_full_name(repo_record)
  sql = f"""
    create table {table_name}_commits as 
      select
        sha,
        html_url,
        repository_full_name,
        author_login,
        author_date,
        message,
        commit->'author'->>'email' as author_email,
        commit->'author'->>'name' as author_name,
        committer_login,
        commit->'committer'->'email'->>'email' as committer_email,
        commit->'committer'->'name'->>'name' as committer_name
      from
        github_commit
      where
        repository_full_name = '{repo_record['full_name']}'
  """
  print(sql)
  sql_write(sql)

def create_commit_tables_for_all_repos(org):
  repos = get_repos()
  for repo_record in repos:
    create_commits_table_for_repo(repo_record)

def drop_commit_tables_for_all_repos(org):
  repos = get_repos()
  for repo_record in repos:
    table_name = table_name_from_repo_full_name(repo_record)
    sql = f"drop table {table_name}_commits"
    print(sql)
    sql_write(sql)

def drop_members_join_commits():
  sql = f"drop table members_join_commits"
  print(sql)
  sql_write(sql)

def drop_turbot_external_commits():
  sql = f"drop table turbot_external_commits"
  print(sql)
  sql_write(sql)


def combine_tables(org):
  repos = get_repos()
  statements = []
  for repo_record in repos:
    table_name = table_name_from_repo_full_name(repo_record)
    statements.append(f'select * from {table_name}_commits')
  sql = ' union '.join(statements)
  sql = f'create table {org}_external_commits as ' + sql
  print(sql)
  sql_write(sql)
  sql = f"delete from {org}_external_commits where author_login in ( {exclude} )"
  print(sql)
  sql_write(sql)

def join_tables(org):
  sql = f"""
    create table members_join_commits as
      select
        c.repository_full_name,
        c.author_login,
        to_char(c.author_date, 'YYYY-MM-DD') as author_date,
        c.html_url,
        c.message
      from
        {org}_external_commits c
      left join
        {org}_members m
      on 
        m.member_login = author_login
      where
        m.member_login is null
        and c.author_login !~* 'dependabot'
      order by
        author_date desc
  """
  print(sql)
  sql_write(sql)

def table_name_from_repo_full_name(repo_record):
  full_name = repo_record['full_name']
  match = re.match('(.+)/(.+)', full_name).groups()
  return match[1].replace('-','_')

dashboard_template = """
mod "GitHubContribs" {
  title = "GitHubContribs"
}
dashboard "GitHubContribs" {

  table {
    title = "__ORG__ external commits"
      sql = <<EOQ
      select
        c.repository_full_name,
        c.author_login,
        to_char(c.author_date, 'YYYY-MM-DD') as author_date,
        c.html_url,
        c.message
      from
        __ORG___external_commits c
      left join
        __ORG___members m
      on 
        m.member_login = author_login
      where
        m.member_login is null
        and c.author_login !~* 'dependabot'
      order by
        author_date desc
    EOQ
    column "html_url" {
      wrap = "all"
    }
    column "message" {
      wrap = "all"
    }
  }

}
"""

org = 'turbot'
exclude = """
  'LalitLab',
  'Priyanka585464',
  'c0d3r-arnab',
  'Paulami30',
  'RupeshPatil20',
  'akumar-99',
  'anisadas',
  'debabrat-git',
  'krishna5891',
  'rajeshbal65',
  'sayan133',
  'shivani1982',
  'subham9418',
  'visiit'
"""

drop_turbot_external_commits()

drop_members_join_commits()

drop_commit_tables_for_all_repos(org)

create_org_members_table(org)

create_commit_tables_for_all_repos(org)

combine_tables(org)

join_tables(org)

