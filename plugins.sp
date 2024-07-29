dashboard "Plugins" {
    
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
        "[Plugins](${local.host}/steampipe_stats.dashboard.Plugins)",
        "Plugins"
      )
    }

  }

  container {


    chart {
      series "turbot_plugins" {
        color = "lightblue"
      }
      series "non_turbot_plugins" {
        color = "orange"
      }
      sql = <<EOQ
        with months as (
          select date_trunc('month', series) as month
          from generate_series(
              '2021-01-01'::timestamp,
              current_date,
              '1 month'::interval
          ) as series
        ),
        turbot_plugins as (
          select
            date(to_char(date(date), 'YYYY-MM') || '-01') as month,
            count(*) as turbot_plugins
          from
            plugin_initial_versions
          where
            repository_full_name ~ 'turbot'
          group by
            month
          order by
            month
        ),
        non_turbot_plugins as (
          select
            date(to_char(date(date), 'YYYY-MM') || '-01') as month,
            count(*) as non_turbot_plugins
          from
            plugin_initial_versions
          where
            repository_full_name !~ 'turbot'
          group by
            month
          order by
            month
        )
        select 
          month, turbot_plugins, non_turbot_plugins
        from
          months
        left join
          turbot_plugins using (month)
        left join
          non_turbot_plugins using (month)
      EOQ
    }

    text {  value = "using date of v0.0.1 tag as proxy for release date"  }

    table {
      width = 6
      sql = <<EOQ
        select 
          date,
          repository_full_name
        from
          plugin_initial_versions
        order by
          date desc
      EOQ
    }

  }

}
