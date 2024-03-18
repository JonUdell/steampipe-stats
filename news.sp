dashboard "News" {
  
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
        "[News](${local.host}/steampipe_stats.dashboard.News)",
        "News"
      )
    }

  }
  
  chart {
    axes {
      x {
        title {
          value = "months"
        }
      }
      y {
        title {
          value = "articles"
        }
      }
    }
    width = 6
    sql = <<EOQ
      with months as (
        select 
          to_char(
            generate_series (
              date('2021-01-01'),
              now()::date,
              '1 month'::interval
            ),
            'YYYY-MM'
          ) as month
      ),
      article_months as (
        select
          (regexp_matches(response_body, '>(\d{4,4}\-\d{2,2})-\d{2,2}<', 'g'))[1]  as article_month,
          count(*)
        from
          net.net_http_request
        where 
          url = 'https://steampipe.io/blog/news-and-reviews'
        group by
          article_month
        order by
          article_month
      )
      select 
        date(month || '-01') as month,
        coalesce(count, 0) as count
      from 
        months 
      left join
        article_months
      on
        month = article_month
    EOQ
  }


}

