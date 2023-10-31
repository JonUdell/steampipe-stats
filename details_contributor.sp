dashboard "DetailsContributor" {

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
        "[DetailsContributor](${local.host}/steampipe_stats.dashboard.DetailsContributor)",
        "DetailsContributor"
      )
    }

  }

  container {

    input "person" {
      width = 2
      type = "text"
      }

    container {

      chart {
        args = [ self.input.person.value ]
        sql = <<EOQ
          select
              date_trunc('month', author_date::date) as month,
              count(*)
          from
              members_join_commits
          where
            author_login = $1
          group by
              month
          order by
              month;
        EOQ
      }


      table {
        args = [ self.input.person.value ]
        title = "contributor detail"
          sql = <<EOQ
          select
            *
          from
            members_join_commits
          where
            author_login = $1
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
