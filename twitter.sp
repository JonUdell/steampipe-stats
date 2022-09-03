dashboard "Twitter" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 4
      value = <<EOT
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
[Stargazers](${local.host}/steampipe_stats.dashboard.Stargazers)
🞄
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
Twitter
      EOT
    }
  }

  table {
    sql = <<EOQ
      with data as (
        select 
          id,
          text,
          created_at,
          author ->> 'username' as username,
          author ->> 'name' as name,
          author -> 'public_metrics' ->> 'followers_count' as followers
        from
          twitter_search_recent
        where
          query = 'steampipe'
      )
      select
        id,
        to_char(created_at, 'YYYY-MM-DD HH24:mm') as created,
        username,
        followers,
        text
      from
        data 
      order by 
        created_at desc
    EOQ
    column "id" {
      href = "https://twitter.com/{{.'username'}}/status/{{.'id'}}"
    }
    column "text" {
      wrap = "all"
    }    
    column "username" {
      href = "https://twitter.com/{{.'username'}}"
    }    

  }

}


