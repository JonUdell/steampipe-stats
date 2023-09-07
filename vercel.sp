dashboard "Vercel" {

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
        "[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)",
        "Vercel"
      )
    }

  }

 
  container {

    table {
      sql = <<EOQ
        with data as (
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
        limit 100
        )
        select
          *
        from
          data
        order by
          created desc
      EOQ
    }

  }
}

