  dashboard "Repos" {
    
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
  Repos
  🞄
  [Slack](${local.host}/steampipe_stats.dashboard.Slack)
  🞄
  [Stargazers](${local.host}/steampipe_stats.dashboard.Stargazers)
  🞄
  [Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
  🞄
  [Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
          EOT
      }
    }

    container {

      input "repo" {
        width = 4
        title = "community repo"
        sql = <<EOQ
          select
            full_name as label,
            full_name as value
          from
            github_search_repository
          where
            query = 'steampipe in:name'
          order by
            full_name
        EOQ
      }

      input "since" {
        width = 4
        title = "since 3 MO, 6 MO, 1 YR, 2YR ago"
        sql = <<EOQ
          with days(day) as (
            values 
                      ( to_char(now() - interval '3 month', 'YYYY-MM-DD') ),
              ( to_char(now() - interval '6 month', 'YYYY-MM-DD') ),
              ( to_char(now() - interval '1 year', 'YYYY-MM-DD') ),
              ( to_char(now() - interval '2 year', 'YYYY-MM-DD') )
          )
          select
            day as label,
            day as value
          from 
            days
          order by 
            day desc
        EOQ    
      }

    }  

    table {
      args = [ self.input.repo, self.input.since ]
      sql = <<EOQ
        with repos as (
          select
            full_name,
            'committer-date:>' || $2 || ' repo:' || full_name as query
          from
            github_search_repository
          where
            query = $1 || ' in:name'
          order by
            full_name
        )
        select
          full_name,
          substring(c.commit -> 'committer' ->> 'date' from 1 for 10) as date,
          c.commit ->> 'message' as message,
          sha
        from
          repos r
        join
          github_search_commit c 
        on
          r.full_name = c.repository_full_name
        where
          c.query =  r.query
        order by
          full_name, date desc
      EOQ
      column "full_name" {
        href = "https://github.com/{{.'full_name'}}"
      }
      column "message" {
        wrap = "all"
      }
      column "sha" {
        href = "https://github.com/{{.'full_name'}}/commit/{{.'sha'}}"
      }

    }

  }
