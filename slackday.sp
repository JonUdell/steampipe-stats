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
    title = "day"
    width = 2
    input "day" {
      type = "combo"
      sql = <<EOQ
      with data as (
        select
          to_char(now() - interval '1 day' * row_num, 'YYYY-MM-DD') as day
        from
          generate_series(0,30) as row_num
      )
      select
        day as label,
        day as value
      from
        data
      order by
        day desc
      EOQ
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



  