
mod "steampipe_stats" {
  title = "Steampipe Stats"
}

locals {
  host = "https://cloud.steampipe.io/org/acme/workspace/jon/dashboard"
  //host = "http://localhost:9194"
  menu = <<EOT
[Contributors](__HOST__/steampipe_stats.dashboard.Contributors)
🞄
[DetailsContributor](__HOST__/steampipe_stats.dashboard.DetailsContributor)
🞄
[Links](__HOST__/steampipe_stats.dashboard.Links)
🞄
[Mentions](__HOST__/steampipe_stats.dashboard.Mentions)
🞄
[Mods](__HOST__/steampipe_stats.dashboard.Mods)
🞄
[News](__HOST__/steampipe_stats.dashboard.News)
🞄
[Reddit](__HOST__/steampipe_stats.dashboard.Reddit)
🞄
[Repos](__HOST__/steampipe_stats.dashboard.Repos)
🞄
[Slack](__HOST__/steampipe_stats.dashboard.Slack)
🞄
[SlackDay](__HOST__/steampipe_stats.dashboard.SlackDay)
🞄
[Stargazers](__HOST__/steampipe_stats.dashboard.Stargazers)
🞄
[Traffic](__HOST__/steampipe_stats.dashboard.Traffic)
🞄
[Vercel](__HOST__/steampipe_stats.dashboard.Vercel)  
EOT
}

