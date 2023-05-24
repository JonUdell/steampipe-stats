dashboard "SlackDay" {

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
        "[SlackDay](${local.host}/steampipe_stats.dashboard.SlackDay)",
        "SlackDay"
      )
    }

  }

  container {
    title = "day (YYYY-MM-DD)"
    width = 2
    input "day" {
      type = "text"
    }
  } 

  container {

    table {
      args = [ self.input.day ]
      sql = <<EOQ
        select
          user_name,
          user_id,
          to_char(timestamp, 'YYYY-MM-DD HH24:MI'),
          text
        from
          slack_search
        where
          query =  'in:#steampipe on:' || $1
        order by 
          timestamp
      EOQ
      column "text" {
        wrap = "all"
      }
    }

  }

 
}



  