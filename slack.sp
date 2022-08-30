dashboard "slack" {

  tags = {
    service = "Steampipe Stats"
  }

  title = "Slack Membership"
  card {
    sql = <<EOQ
      select 
        count(*) as members
      from 
        slack_user
    EOQ
  }
                                                                                                                                                                                                                                                                                                           
  chart {
    title = "New members by month"
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



