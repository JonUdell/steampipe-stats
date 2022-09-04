dashboard "HackerNews" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 6
      value = <<EOT
Hacker News
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
[Stargazers](${local.host}/steampipe_stats.dashboard.Stargazers)
🞄
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
      EOT
    }
  }

  container {

    table {
      base = table.search_hackernews
      query = query.search_hackernews
      title = "sql"
      args = [ "sql" ]
    }

    table {
      base = table.search_hackernews
      query = query.search_hackernews
      title = "postgres"
      args = [ "postgres" ]
    }

    table {
      base = table.search_hackernews
      query = query.search_hackernews
      title = "api"
      args = [ " api " ]
    }

    table {
      base = table.search_hackernews
      query = query.search_hackernews
      title = "compliance"
      args = [ "compliance" ]
    }

    table {
      base = table.search_hackernews
      query = query.search_hackernews
      title = "steampipe"
      args = [ "steampipe" ]
    }



  }

}

query "search_hackernews" {
  sql = <<EOQ
    select id, to_char(time, 'YYYY-MM-DD HH24:mm') as time, by, score, descendants, title, url from hackernews_new where title ~* $1 or url ~* $1 or text ~* $1
    union 
    select id, to_char(time, 'YYYY-MM-DD HH24:mm') as time, by, score, descendants, title, url from hackernews_ask_hn where title ~* $1 or url ~* $1 or text ~* $1
    union
    select id, to_char(time, 'YYYY-MM-DD HH24:mm') as time, by, score, descendants, title, url from hackernews_show_hn where title ~* $1 or url ~* $1 or text ~* $1
    order by score desc
  EOQ
  param "search_term" {}
}

table "search_hackernews" {
  column "id" {
    href = "https://news.ycombinator.com/item?id={{.'id'}}"
  }
  column "title" {
    wrap = "all"
  }
  column "by" {
    href = "https://news.ycombinator.com/user?id={{.'by'}}"
  }
  column "url" {
    wrap = "all"
  }
}



  