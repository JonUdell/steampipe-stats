dashboard "Traffic" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    
    text {
      width = 8
      value = replace(
        replace(
          "${local.menu}",
          "__HOST__",
          "${local.host}"
        ),
        "[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)",
        "Traffic"
      )
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

  }

}
