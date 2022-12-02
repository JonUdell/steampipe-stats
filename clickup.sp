dashboard "Clickup" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 8
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
[Reddit](${local.host}/steampipe_stats.dashboard.Reddit)
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
      column "name" {
        wrap = "all"
      }
      column "preview_url" {
        wrap = "all"
      }
      column "pr_url" {
        wrap = "all"
      }
      column "url" {
        wrap = "all"
      }
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
    ),
    custom_fields as (
      select
        task ->> 'id' as task_id,
        jsonb_array_elements( task -> 'custom_fields' ) as custom_field
    from 
      tasks
    ),
    preview_urls as (
      select 
        task_id,
        custom_field ->> 'value' as preview_url
      from
        custom_fields
      where
        custom_field ->> 'name' = 'Vercel Preview URL'
    ),
    pr_urls as (
      select 
        task_id,
        custom_field ->> 'value' as pr_url
      from
        custom_fields
      where
        custom_field ->> 'name' = 'GitHub Pull Request'
    )
    select
      t.task ->> 'name' as name,
      t.task -> 'status' ->> 'status' as status,
      t.task -> 'list' ->> 'name' as list_name,
      t.task -> 'creator' ->> 'username' as creator,
      t.task -> 'assignees' -> 0 ->> 'username' as assignee,
      to_char( to_timestamp( (t.task ->> 'date_created')::numeric / 1000 ), 'YYYY-MM-DD' ) as date_created,
      to_char( to_timestamp( (t.task ->> 'date_updated')::numeric / 1000 ),  'YYYY-MM-DD') as date_updated,
      t.task ->> 'url' as url,
      p.preview_url,
      pr.pr_url
    from
      tasks t
    join
      preview_urls p 
    on
      t.task ->> 'id' = p.task_id
    join
      pr_urls pr
    on
      t.task ->> 'id' = pr.task_id
    order by
      task ->> 'date_updated' desc  


      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
  EOQ
}