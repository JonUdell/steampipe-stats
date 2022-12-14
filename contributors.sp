dashboard "Contributors" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    
    text {
      width = 8
      value = <<EOT
[Clickup](${local.host}/steampipe_stats.dashboard.Clickup)
🞄
Contributors
🞄
[DetailsContributor](${local.host}/steampipe_stats.dashboard.DetailsContributor)
🞄
[Links](${local.host}/steampipe_stats.dashboard.Links)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Reddit](${local.host}/steampipe_stats.dashboard.Reddit)
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

    card {
      width = 2
      sql = <<EOQ
        select count(*) as "external commits" from members_join_commits
      EOQ
    }

    card {
      width = 2
      sql = "select min(author_date) as oldest from members_join_commits"
    }

    card {
      width = 2
      sql = "select max(author_date) as newest from members_join_commits"
    }

  }

  container {

    table {
      title = "turbot external committers by count"
      width = 4
      sql = <<EOQ
        with data as (
          select 
            author_login,
            count(*)
          from 
            members_join_commits
          group by
            author_login
        )
        select
          author_login,
          ( select min(author_date) as oldest from members_join_commits m where m.author_login = d.author_login),
          ( select max(author_date) as newest from members_join_commits m where m.author_login = d.author_login),
          ( select count(*) as contribs from members_join_commits m where m.author_login = d.author_login)
        from 
          data d
        order by
          contribs desc
      EOQ
      column "author_login" {
        href = "${local.host}/steampipe_stats.dashboard.DetailsContributor?input.person={{.'author_login'}}"      
      }

    }

    table {
      width = 8
      title = "turbot external commits by recency"
        sql = <<EOQ
        select
          *
        from
          members_join_commits
      EOQ
      column "html_url" {
        wrap = "all"
      }
      column "message" {
        wrap = "all"
      }
    }

  }

}
