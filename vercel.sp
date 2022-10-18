dashboard "Vercel" {

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
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
.
Vercel
      EOT
    }
  }

  container {

    table {
      sql = <<EOQ
        with deployments as (
          select 
            jsonb_array_elements(latest_deployments) as deployment
          from
            vercel_project
        )
        select
          to_char(to_timestamp((deployment ->> 'createdAt')::bigint / 1000), 'YYYY-MM-DD HH24:MM') as created_at,
          deployment -> 'creator' ->> 'githubLogin' as creator,
          'https://' || (deployment ->> 'url') as url,
          deployment ->> 'readyState' as "ready?",
          deployment -> 'meta' ->> 'githubCommitMessage' as commit
        from
          deployments
        order by
          deployment ->> 'createdAt' desc
      EOQ
      column "commit" {
        wrap = "all"
      }
    }

  }
}

