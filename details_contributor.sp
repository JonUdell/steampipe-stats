dashboard "DetailsContributor" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    
    text {
      width = 8
      value = <<EOT
[Clickup](${local.host}/steampipe_stats.dashboard.Clickup)
🞄
[Contributors](${local.host}/steampipe_stats.dashboard.Contributors)
🞄
DetailsContributor
🞄
[Links](${local.host}/steampipe_stats.dashboard.Links)
🞄
[Mentions](${local.host}/steampipe_stats.dashboard.Mentions)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Reddit](${local.host}/steampipe_stats.dashboard.Reddit)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
[Stargazers](${local.host}/steampipe_stats.dashboard.Slack)
🞄
[Traffic](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
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
