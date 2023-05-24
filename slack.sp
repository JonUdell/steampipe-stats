dashboard "Slack" {

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
        "[Slack](${local.host}/steampipe_stats.dashboard.Slack)",
        "Slack"
      )
    }

  }

  card {
    width = 2
    sql = <<EOQ
      select 
        count(*) as members
      from 
        slack_user
    EOQ
  }

  container {
                                                                                                                                                                                                                                                                                                           
    chart {
      title = "New members by month"
      width = 6
      type = "line"
      sql = <<EOQ
        with months as (
          select
            to_char(updated, 'YYYY-MM') as month
          from 
            slack_user
          where
            updated is not null
        )
        select
          month,
          count(*)
        from
          months
        where 
          month <= ( select to_char(now(), 'YYYY-MM') )
        group by
          month
      EOQ
    }

  chart {
      title = "Cumulative members by month"
      width = 6
      type = "line"
      sql = <<EOQ
        with data as (
          with months as (
            select
              to_char(updated, 'YYYY-MM') as month
            from 
              slack_user
            where
              updated is not null
          )
          select
            month,
            count(*)
          from
            months
          where 
            month <= ( select to_char(now(), 'YYYY-MM') )
          group by
            month
        )
          select
            month,
            sum(count) over (order by month asc rows between unbounded preceding and current row)
          from
            data
      EOQ
    }

  }

  container {

    chart {
      width = 3
      type = "donut"
      title = "Members by tz region"
      sql = <<EOQ
        with data as (
          select
            (regexp_match(tz, '^(.+)/'))[1] as region
          from 
            slack_user
        )
        select
          region,
          count(*)
        from 
          data
        group by 
          region 
        order by
          count desc    
        EOQ
    }

    chart {
      width = 3
      type = "donut"
      title = "Members by tz city"
      sql = <<EOQ
        with data as (
          select
            (regexp_match(tz, '^.+/(.+)'))[1] as city
          from
            slack_user
        )
        select
          city,
          count(*)
        from 
          data
        group by 
          city
        order by
          count desc    
        EOQ
    }
    
  }

  container {

    table {
      width = 6
      title = "members by email domain: summary"
      sql = <<EOQ
        select 
          (regexp_match(email, '@(.+)'))[1] as domain,
          count(*)
        from
          slack_user
        group by
          domain
        order by
          count desc
        EOQ
      }

    table {
      width = 6
      title = "members by email domain: detail"
      sql = <<EOQ
        select 
          (regexp_match(email, '@(.+)'))[1] as domain,
          email
        from
          slack_user
        order by 
          domain
        EOQ
      }




  }

 
}



  