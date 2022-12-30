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

  table {
    width = 3
      title = "Total stargazers by plugin repo"
      sql = <<EOQ
        select
          repo,
          sum(count)
        from
          github_stargazers_monthly
        where
          repo ~ '_plugin_'
        group by
          repo
        order by
          sum desc
      EOQ
    }

  table {
    title = "Total stargazers by mod repo"
    width = 3
    sql = <<EOQ
      select
        repo,
        sum(count)
      from
        github_stargazers_monthly
      where
        repo ~ '_mod_'
      group by
        repo
      order by
        sum desc
    EOQ
  }

  table {
    title = "New and cumulative stargazers by repo and month"
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
