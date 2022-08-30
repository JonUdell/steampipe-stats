dashboard "Mod_Stats" {
  
  tags = {
    service = "Steampipe Stats"
  }
                                                                                                                                                                                                                                                                                                           
  table {
    width = 5
    title = "Total counts of mod controls, queries, dashboards, and variables"
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
        match[2] as controls,
        match[3] as queries,
        match[4] as dashboards,
        match[5] as variables
        from matches
        )
        select
        sum(controls::int) as controls,
        sum(queries::int) as queries,
        sum(dashboards::int) as dashboards
        from
        data
    EOQ
  }

  table {
    width = 7
    title = "Per-mod counts of controls, queries, dashboards, and variables"
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

