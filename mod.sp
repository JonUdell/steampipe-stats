
mod "steampipe_stats" {
  title = "Steampipe Stats"
}

locals {
  host = "https://pipes.turbot.com/org/turbot-ops/workspace/stats/dashboard"
  //host = "http://localhost:9033"
  menu = <<EOT
[Contributors](__HOST__/steampipe_stats.dashboard.Contributors)
🞄
[DetailsContributor](__HOST__/steampipe_stats.dashboard.DetailsContributor)
🞄
[Links](__HOST__/steampipe_stats.dashboard.Links)
🞄
[Mods](__HOST__/steampipe_stats.dashboard.Mods)
🞄
[News](__HOST__/steampipe_stats.dashboard.News)
🞄
[Repos](__HOST__/steampipe_stats.dashboard.Repos)
🞄
[Slack](__HOST__/steampipe_stats.dashboard.Slack)
🞄
[Stargazers](__HOST__/steampipe_stats.dashboard.Stargazers)
🞄
[Traffic](__HOST__/steampipe_stats.dashboard.Traffic)
🞄
[Vercel](__HOST__/steampipe_stats.dashboard.Vercel)  
EOT
}

