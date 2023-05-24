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
