dashboard "Stargazers" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 8
      value = <<EOT
[Clickup](${local.host}/steampipe_stats.dashboard.Clickup)
🞄
[Contributors](${local.host}/steampipe_stats.dashboard.Contributors)
🞄
[DetailsContributor](${local.host}/steampipe_stats.dashboard.DetailsContributor)
🞄
[Mentions](${local.host}/steampipe_stats.dashboard.Mentions)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Reddit](${local.host}/steampipe_stats.dashboard.Reddit)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
Stargazers
🞄
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
.
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
    }
  }

  container {

    chart {
      width = 4
      title = "steampipe"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-pugin-aws"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_plugin_aws' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-aws-insights"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_aws_insights' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-aws-compliance"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_aws_compliance' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-aws-perimeter"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_aws_perimeter' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-aws-thrifty"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_aws_thrifty' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-pugin-azure"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_plugin_azure' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-azure-compliance"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_azure_compliance' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-pugin-gcp"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_plugin_gcp' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-gcp-compliance"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_gcp_compliance' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-zoom-compliance"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_zoom_compliance' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-plugin-github"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_plugin_github' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-github-sherlock"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_github_sherlock' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-plugin-kubernetes"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_plugin_kubernetes' order by month
      EOQ
    }

    chart {
      width = 4
      title = "steampipe-mod-kubernetes-compliance"
      type = "line"
      sql = <<EOQ
        select month, sum from github_stargazers_cumulative where repo = 'steampipe_mod_kubernetes_compliance' order by month
      EOQ
    }


  }

  container {

    table {
      title = "Total stars by repo"
      width = 4
      sql = <<EOQ
        select
          repo,
          max(sum) as total
        from
          github_stargazers_cumulative c
        group by
          repo
        order by total desc
      EOQ
    }

    table {
      title = "New and cumulative stars by repo and month"
      width = 4
      sql = <<EOQ
        select
          m.repo,
          m.month,
          m.count as new,
          c.sum as cumulative
        from
          github_stargazers_monthly m
        join
          github_stargazers_cumulative c
        on
          m.repo = c.repo
          and m.month = c.month
        order by
          m.repo, m.month
      EOQ
    }


  }

}
