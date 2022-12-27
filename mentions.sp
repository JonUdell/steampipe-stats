dashboard "Mentions" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 8
      value = <<EOT
[Clickup](${local.host}/steampipe_stats.dashboard.Clickup)
🞄
[Contributors](${local.host}/steampipe_stats.dashboard.Contributors)
🞄
[DetailsContributor](${local.host}/steampipe_stats.dashboard.DetailsContributor)
🞄
[Links](${local.host}/steampipe_stats.dashboard.Links)
🞄
Mentions
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Reddit](${local.host}/steampipe_stats.dashboard.Reddit)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
Slack
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
                                                                                                                                                                                                                                                                                                           
    table {
      title = "Reddit mentions"
      width = 6
      sql = <<EOQ
        select 
          to_char(created_utc, 'YYYY-MM-DD') as created_at,
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
        select
          'https://www.twitter.com/' || (author->>'username') || '/status/' || id as url,
          to_char(created_at, 'YYYY-MM-DD') as created_at,
          (author ->> 'username') || ' ' || (author -> 'public_metrics' ->> 'followers_count') || ' _' || text || '_' as tweet
        from
          twitter_search_recent
        where
          query = 'steampipe'
          and author ->> 'username' != 'steampipeio'
          and text ~* 'steampipe'
        order by created_at desc
        limit 15
      EOQ
      column "author" {
        wrap = "all"
      }
      column "tweet" {
        wrap = "all"
      }
    }


  }


}



  