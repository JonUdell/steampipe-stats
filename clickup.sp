dashboard "Clickup" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 6
      value = <<EOT
Clickup
🞄
[Hacker News](${local.host}/steampipe_stats.dashboard.HackerNews)
🞄
[Links](${local.host}/steampipe_stats.dashboard.Links)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
[Stargazers](${local.host}/steampipe_stats.dashboard.Slack)
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
    table {
      query = query.clickup_tasks
    }

  }

}

query "clickup_tasks" {
  sql = <<EOQ
    with response_body as (
      select 
        response_body::jsonb
      from  
      net_http_request 
      where
        url = 'https://api.clickup.com/api/v2/team/36736759/task'
        and request_headers = jsonb_object( array ['authorization', clickup_token() ] ) 
    ),
    tasks as (
      select
        jsonb_array_elements( response_body -> 'tasks' ) as task
      from 
        response_body
    )
    select
      task ->> 'name' as name,
      task -> 'status' ->> 'status' as status,
      task -> 'list' ->> 'name' as list_name,
      task -> 'creator' ->> 'username' as creator,
      task -> 'assignees' -> 0 ->> 'username' as assignee,
      to_char( to_timestamp( (task ->> 'date_created')::numeric / 1000 ), 'YYYY-MM-DD' ) as date_created,
      to_char( to_timestamp( (task ->> 'date_updated')::numeric / 1000 ),  'YYYY-MM-DD') as date_updated,
      task ->> 'url' as url
    from
      tasks
    order by
      task ->> 'date_updated' desc  

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
  EOQ
}