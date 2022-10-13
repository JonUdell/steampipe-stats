dashboard "Twitter" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 6
      value = <<EOT
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
[Stargazers](${local.host}/steampipe_stats.dashboard.Stargazers)
🞄
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
Twitter
.
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
    }
  }

  container {

   card {
     width = 2
     sql = <<EOQ
       select 
        public_metrics ->> 'followers_count' as followers
      from
        twitter_user
      where
        username = 'steampipeio'
     EOQ
   }

   card {
     width = 2
     sql = <<EOQ
       select 
        public_metrics ->> 'listed_count' as lists
      from
        twitter_user
      where
        username = 'steampipeio'
     EOQ
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


