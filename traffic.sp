dashboard "Traffic" {

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
[Links](${local.host}/steampipe_stats.dashboard.Links)
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
[Stargazers](${local.host}/steampipe_stats.dashboard.Stargazers)
🞄
Traffic
🞄
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
    }
  }

  container {
    
    card {
      width = 2
      sql = <<EOQ
        select min(day) as "first day" from github_traffic
      EOQ
    }

    card {
      width = 2
      sql = <<EOQ
        select max(day) as "last day" from github_traffic
      EOQ
    }

  }

  container {

    table {
      title = "Unique views of GitHub repos by repo and day, last 2 weeks"
      width = 5
      sql = <<EOQ
        select
          *
        from
          github_traffic
        where
          uniques > 1
        order by
          uniques desc
      EOQ
    }

    table {
      width = 4
      title = "Unique views of GitHub repos by repo, last 2 weeks"
      sql = <<EOQ
        select
          repo,
          sum(uniques)
        from
          github_traffic
        group by
          repo
        order by
          sum desc

      EOQ
    }


  }

}
