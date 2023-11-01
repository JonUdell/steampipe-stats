dashboard "Contributors" {

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
        "[Contributors](${local.host}/steampipe_stats.dashboard.Contributors)",
        "Contributors"
      )
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
      title = "turbot external committers by count (v0.58)"
      width = 6
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

    container {
      width = 6

      chart {
        sql = <<EOQ
          select
              date_trunc('month', author_date::date) as month,
              count(*)
          from
              members_join_commits
          group by
              month
          order by
              month;
        EOQ
      }

      table {
        title = "turbot external commits by recency"
          sql = <<EOQ
          select
            *
          from
            members_join_commits
          order by
            author_date desc
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

}
