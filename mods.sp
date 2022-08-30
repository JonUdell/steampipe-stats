dashboard "Mod_Stats" {
  
  tags = {
    service = "Steampipe Stats"
  }
                                                                                                                                                                                                                                                                                                           
  table {
    title = "Counts of controls, queries, dashboards, and variables"
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

