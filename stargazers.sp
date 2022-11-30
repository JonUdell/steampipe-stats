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
[Hacker News](${local.host}/steampipe_stats.dashboard.HackerNews)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
Stargazers
🞄
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
.
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
    }
  }

container {
  width = 6
  text {
    value = <<EOT
This dashboard reports stargazers by month for selected repos. The live version takes a while to load, and seems to require multiple refreshes to fully load. While waiting you can view snapshots. 

[11/29/2022](https://cloud.steampipe.io/org/acme/workspace/jon/snapshot/snap_ce39rdsehsemu8drufkg_1usouc9m5ah8x4ubkmsyx8sa9)
	EOT
  }
}


  container {

    card {
      width = 2
      sql = <<EOQ
        select 
          count(*) as "steampipe"
            from 
          github_stargazer 
        where 
          repository_full_name = 'turbot/steampipe'
      EOQ
    }

    card {
      width = 2
      sql = <<EOQ
        select 
          count(*) as "plugin-aws"
            from 
          github_stargazer 
        where 
          repository_full_name = 'turbot/steampipe-plugin-aws'
      EOQ
    }

    card {
      width = 2
      sql = <<EOQ
        select 
          count(*) as "mod-aws-compliance"
            from 
          github_stargazer 
        where 
          repository_full_name = 'turbot/steampipe-mod-aws-compliance'
      EOQ
    }

    card {
      width = 2
      sql = <<EOQ
        select 
          count(*) as "mod-aws-insights"
            from 
          github_stargazer 
        where 
          repository_full_name = 'turbot/steampipe-mod-aws-insights'
      EOQ
    }

    card {
      width = 2
      sql = <<EOQ
        select 
          count(*) as "mod-aws-perimeter"
            from 
          github_stargazer 
        where 
          repository_full_name = 'turbot/steampipe-mod-aws-perimeter'
      EOQ
    }

    card {
      width = 2
      sql = <<EOQ
        select 
          count(*) as "mod-aws-thrifty"
            from 
          github_stargazer 
        where 
          repository_full_name = 'turbot/steampipe-mod-aws-thrifty'
      EOQ
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

  container {
    title = "turbot/steampipe-mod-aws-perimeter"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-perimeter" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-perimeter" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-mod-aws-thrifty"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-thrifty" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-mod-aws-thrifty" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-azure"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-azure" ]
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-azure" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-azuread"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-azuread" ]
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-azuread" ]
      query = query.new_stargazers_by_month
    }

  }


  container {
    title = "turbot/steampipe-plugin-crowdstrike"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-crowdstrike" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-crowdstrike" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-duo"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-duo" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-duo" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-github"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-github" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-github" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-googlesheets"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-googlesheets" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-googlesheets" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-googleworkspace"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-googleworkspace" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-googleworkspace" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-hackernews"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-hackernews" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-hackernews" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-mod-hackernews-insights"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-mod-hackernews-insights" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-mod-hackernews-insights" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-kubernetes"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-kubernetes" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-kubernetes" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-net"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-net" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-net" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-mod-net-insights"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-mod-net-insights" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-mod-net-insights" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-salesforce"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-salesforce" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-salesforce" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-samples"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-samples" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-samples" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-slack"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-slack" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-slack" ]
      query = query.new_stargazers_by_month
    }

  }


  container {
    title = "turbot/steampipe-plugin-terraform"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-terraform" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-terraform" ]
      query = query.new_stargazers_by_month
    }

  }

  container {
    title = "turbot/steampipe-plugin-trivy"

    chart {
      width = 6
      title = "cumulative stargazers"
      type  = "line"
      args = [ "turbot/steampipe-plugin-trivy" ] 
      query = query.cumulative_stargazers
    }

    chart {
      width = 6
      title = "new stargazers by month"
      type  = "line"
      args = [ "turbot/steampipe-plugin-trivy" ]
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