dashboard "Stargazers" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 2
      value = <<EOT
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
Stargazers
      EOT
    }
  }


  container {
    title = "turbot/steampipe"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe" ]
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-aws"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-aws" ]
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-aws" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-mod-aws-compliance"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-compliance" ]      
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-compliance" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-mod-aws-insights"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-insights" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-insights" ]
      query = query.new_stargazers_by_month
    }

  }

}

query "cumulative_stargazers" {
  sql = <<EOQ
    with data as (
      select
        to_char(starred_at, 'YYYY-MM') as month,
        count(*)
      from
        github_stargazer
      where
        repository_full_name = $1
        and to_char(starred_at, 'YYYY-MM') <= ( select to_char(now(), 'YYYY-MM'))
      group by
        month
      order by
        month
    )
    select
      month,
      sum(count) over (order by month asc rows between unbounded preceding and current row)
    from
      data
  EOQ
  param "repo" {}
}

query "new_stargazers_by_month" {
  sql   = <<EOQ
    with data as (
      select
        to_char(starred_at, 'YYYY-MM') as month,
        count(*)
      from
        github_stargazer
      where
        repository_full_name = $1
        and to_char(starred_at, 'YYYY-MM') <= ( select to_char(now(), 'YYYY-MM'))
      group by
        month
      order by
        month
    )
    select
      *
    from
      data
  EOQ
  param "repo" {}
}