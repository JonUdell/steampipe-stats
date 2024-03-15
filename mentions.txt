dashboard "Mentions" {

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
        "[Mentions](${local.host}/steampipe_stats.dashboard.Mentions)",
        "Mentions"
      )
    }

  }

  container {
                                                                                                                                                                                                                                                                                                           
    table {
      title = "Reddit mentions"
      width = 6
      sql = <<EOQ
        select 
          to_char(created_utc, 'MM-DD') as day,
          subreddit,
          author,
          score,
          url
      from
        reddit_subreddit_post_search
      where
         subreddit in ('alibabacloud','aws','azure','bag_o_news','cloud','cloudcomputing','cybersecurity','devops','github','golang','googlecloud','gradientflow','hackernews','hacktoberfest','m365reports','mastodon','microsoft365','netsec','oraclecloud','prometheusmonitoring','salesforce','slack','splunk','sql','tailscale','terraform','zoom')
         and query = 'steampipe'
         and author not in ('stevecio','judell','bobtbot')
      order by
         created_utc desc
      limit 15
      EOQ
    }

    table {
      title = "Twitter mentions"
      width = 6
      // https://twitter.com/spdegabrielle/status/1607554553330733059
      sql = <<EOQ
        with data as (
          select
            to_char(created_at, 'MM-DD') as day,
            id,
            author->>'username' as username,
            author->'public_metrics'->>'followers_count' as followers,
            text as tweet
          from
            twitter_search_recent
          where
            query = 'steampipe'
            and author ->> 'username' != 'steampipeio'
            and text ~* 'steampipe'
          order by created_at desc
          limit 15
        )
        select
          day,
          username || '/status/' || id as link,
          followers,
          tweet
        from
          data
      EOQ
      column "link" {
        href = "https://twitter.com/{{.'link'}}"
      }
      column "author" {
        wrap = "all"
      }
      column "tweet" {
        wrap = "all"
      }
    }


  }


}



  