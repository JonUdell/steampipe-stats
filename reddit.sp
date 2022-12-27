dashboard "Reddit" {
  
  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 8
      value = <<EOT
Clickup
🞄
[Clickup](${local.host}/steampipe_stats.dashboard.Clickup)
🞄
[Contributors](${local.host}/steampipe_stats.dashboard.Contributors)
🞄
[DetailsContributor](${local.host}/steampipe_stats.dashboard.DetailsContributor)
🞄
[Links](${local.host}/steampipe_stats.dashboard.Links)
🞄
[Mentions](${local.host}/steampipe_stats.dashboard.Mentions)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
Reddit
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
    
    input "subreddit_name_match" {
      width = 4
      title = "match subreddit name"
      type = "text"
    }

    input "subreddit_title_match" {
      width = 2
      title = "match title too?"
      type = "select"
      option "no" {}
      option "yes" {}
    }

  }

  container {
    
    chart {
      width = 6
      type = "donut"
      args = [
        self.input.subreddit_name_match,
        self.input.subreddit_title_match
      ]
      sql = <<EOQ
        select
          subscribers,
          display_name || ' (rank=' || rank || ')' as subreddit
        from
          reddit_subreddit_search
        where
          query = $1 
          and display_name ~ $1
          and 
            case 
              when $2 = 'yes' then title ~ $1
              else true
            end
        order by
          subscribers desc
      EOQ
    }

    table {
      width = 6
      args = [
        self.input.subreddit_name_match,
        self.input.subreddit_title_match
      ]
      sql = <<EOQ
        select
          rank,
          subscribers as subs,
          'https://reddit.com/r/' || display_name as subreddit,
          title
        from
          reddit_subreddit_search
        where
          query = $1 
          and display_name ~ $1
          and 
            case 
              when $2 = 'yes' then title ~ $1
              else true
            end
        order by
          rank
      EOQ
      column "title" {
        wrap = "all"
      }
    }

  }

}
