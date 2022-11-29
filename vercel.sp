dashboard "Vercel" {

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
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
.
Vercel
      EOT
    }
  }

  container {

    table {
      sql = <<EOQ
        select 
          to_char(created_at, 'MM-DD HH24:mm') as created,
          state,
          'https://' || url as url,
          creator->>'username' as creator, 
          meta->>'githubCommitRef' as commit_ref, 
          meta->>'githubCommitMessage' as commit_msg 
        from 
          vercel_deployment
        where
          created_at > now() - interval '2 weeks'
        order by
          created_at desc      
      EOQ
    }

  }
}

