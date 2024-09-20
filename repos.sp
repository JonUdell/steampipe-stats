dashboard "Repos" {

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
        "[Repos](${local.host}/steampipe_stats.dashboard.Repos)",
        "Repos"
      )
    }

  }

  container {
    width = 4

    table {
      title = "recent updates to community repos"
      sql   = <<EOQ
        select
          name as "Repo",
          stargazer_count as "Stars",
          url as "URL",
          to_char(pushed_at, 'DD-Mon-YYYY') as "Last Pushed"
        from
          github_search_repository
        where
          query = 'steampipe in:name -org:turbot -org:turbotio -org:turbothq created:>2021-01-21'
        order by
          pushed_at desc
        limit 120
      EOQ
      column "Repo" {
        href = "{{.URL}}"
      }
      column "URL" {
        display = "none"
      }
    }
  }

  container {
    width = 5

    table {
      title = "stars for published plugins"
      sql = <<EOQ
        with repos as (
          select 
            date,
            repository_full_name,
            repository_full_name || ' in:name' as query
          from
            plugin_initial_versions
          order by
            date desc
        ),
        add_stars as (
          select
            r.*,
            gsr.stargazer_count,
            gsr.pushed_at
          from
            github_search_repository gsr
          join
            repos r
          on
            r.repository_full_name = gsr.name_with_owner
          where
            gsr.query = r.query
        )
        select
          repository_full_name, 
          stargazer_count,
          date as published, 
          to_char(pushed_at, 'YYYY-MM-DD') as pushed_at
        from
          add_stars
        order by stargazer_count desc        
      EOQ
    }
  }

  container {
    width = 3

    input "repo" {
      title = "community repo"
      sql   = <<EOQ
            select
              name_with_owner as label,
              name_with_owner as value
            from
              github_search_repository
            where
              query = 'steampipe in:name'
            order by
              name_with_owner
          EOQ
    }

    input "since" {
      title = "updated since"
      sql   = <<EOQ
              with days(interval, day) as (
                values 
                  ( '1 week', to_char(now() - interval '1 month', 'YYYY-MM-DD') ),
                  ( '1 month', to_char(now() - interval '1 month', 'YYYY-MM-DD') ),
                  ( '3 months', to_char(now() - interval '3 month', 'YYYY-MM-DD') ),
                  ( '6 months', to_char(now() - interval '6 month', 'YYYY-MM-DD') ),
                  ( '1 year', to_char(now() - interval '1 year', 'YYYY-MM-DD') ),
                  ( '2 years', to_char(now() - interval '2 year', 'YYYY-MM-DD') )
              )
              select
                interval as label,
                day as value
              from 
                days
              order by 
                day desc
            EOQ    
    }

    table {
      args = [self.input.repo, self.input.since]
      sql  = <<EOQ
          with repos as (
              select
                --$1 as dollar_1,
                --$2 as dollar_2,
                g.name_with_owner as repo_name,  -- Specify an alias for the name column
                'author-date:>' || $2|| ' repo:' || g.name_with_owner as commit_query,
                g.*  -- Explicitly reference only columns from g to prevent unintentional overlaps
              from
                github_search_repository g
              where
                query = $1 || ' in:name ' 
              limit 10
          )
          select
              --r.dollar_1,
              --r.dollar_2,
              r.repo_name,  -- Use the specified alias
              c.commit -> 'author' ->> 'name' as author,
            substring(c.commit -> 'committer' ->> 'date' from 1 for 10) as date,
            c.commit ->> 'message' as message
          from
              repos r
          join
              github_search_commit c 
          on
              r.repo_name = c.repository_full_name
          where
              c.query = r.commit_query  -- Use the constructed query for commits
          order by
            date desc      
        EOQ
      column "repo_name" {
        href = "https://github.com/{{.'repo_name'}}"
      }
      column "message" {
        wrap = "all"
      }
    }

  }

}
