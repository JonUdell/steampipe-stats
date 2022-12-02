dashboard "Mods" {
  
  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 6
      value = <<EOT
[Clickup](${local.host}/steampipe_stats.dashboard.Clickup)
🞄
[Hacker News](${local.host}/steampipe_stats.dashboard.HackerNews)
🞄
[Links](${local.host}/steampipe_stats.dashboard.Links)
🞄
Mods
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
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
.
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
    }
  }

  container {

    card {
      width = 2
      query = query.resource_counts
      title = "controls"
      args = [ 2 ]
    }

    card {
      width = 2
      query = query.resource_counts
      title = "queries"
      args = [ 3 ]
    }

    card {
      width = 2
      query = query.resource_counts
      title = "dashboards"
      args = [ 4 ]
    }

    card {
      width = 2
      query = query.resource_counts
      title = "variables"
      args = [ 5 ]
    }

  }
                                                                                                                                                                                                                                                                                                    
  table {
    width = 7
    sql = <<EOQ
        with matches as (
        select
            (regexp_matches(response_body, '/images/mods/turbot/([^\.]+)\.png","controlCount":(\d+),"queryCount":(\d+),"dashboardCount":(\d+),"variableCount":(\d+)', 'g')) as match
        from
            net.net_http_request
        where url = 'https://hub.steampipe.io/mods'
        )
        select 
        replace(match[1], '-social-graphic', '') as mod,
        match[2] as controls,
        match[3] as queries,
        match[4] as dashboards,
        match[5] as variables
        from matches
    EOQ
  }

}

query "resource_counts" {
  sql = <<EOQ
    with matches as (
      select
        (regexp_matches(response_body, '/images/mods/turbot/([^\.]+)\.png","controlCount":(\d+),"queryCount":(\d+),"dashboardCount":(\d+),"variableCount":(\d+)', 'g')) as match
      from
        net.net_http_request
      where url = 'https://hub.steampipe.io/mods'
      ),
    data as (
      select 
        replace(match[1], '-social-graphic', '') as mod,
        match[$1] as resources
      from matches
      )
    select
      sum(resources::int) as count
    from
      data
    EOQ
    param "match_index" {}
  }