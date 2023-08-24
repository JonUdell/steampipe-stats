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

  with "slack_day_fn" {
    sql = <<EOQ
    create function slack_day(day text) returns table (
      real_name text,
      date_time text,
      text text
    ) as $$
      with id_name_map as (
        with id_name as (
          select
            (regexp_matches(text,'<@(\w+)>', 'g'))[1] as id
          from
            slack_search
          where
            query =  'in:#steampipe on:' || $1
        )
        select distinct
          i.id,
          s.real_name
        from
          id_name i
        join
          slack_user s
        on
          i.id = s.id
      ),
      messages as (
        select
          user_name,
          user_id,
          to_char(timestamp, 'YYYY-MM-DD HH24:MI') as dt,
          text
        from
          slack_search
        where
          query =  'in:#steampipe on:' || $1
      ),
      id_name_transformed as (
        select
          m.user_name,
          m.user_id,
          m.dt,
          coalesce(replace(m.text, i.id, i.real_name), m.text) as text
        from
          messages m
        left join
          id_name_map i
        on
          i.id = (regexp_match(m.text, '<@(\w+)>'))[1]
      )
      select
        (select real_name from slack_user where id = user_id),
        dt,
        regexp_replace(text, '\w+\|', '', 'g') as text
      from
        id_name_transformed
      order by
        dt
    $$ language sql
  EOQ
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
      title = "messages"
      width = 6
      args = [ self.input.day ]
      sql = <<EOQ
        select real_name, date_time, text from slack_day($1)
      EOQ
      column "text" {
        wrap = "all"
      }
    }

    table {
      title = "questions"
      width = 6
      args = [ self.input.day ]
      sql = <<EOQ
        select
          real_name,
          date_time,
          unnest(regexp_matches(text, '\s+[^\?.•]+\?', 'g')) as question
        from
          slack_day($1)
      EOQ
      column "question" {
        wrap = "all"
      }
    }


  }
 
}

