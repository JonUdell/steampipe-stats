dashboard "Links" {

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
[DetailsContributor](${local.host}/steampipe_stats.dashboard.DetailsContributor)
🞄
Links
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
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
.
[Vercel](${local.host}/steampipe_stats.dashboard.Vercel)
      EOT
    }
  }

  container {

    input "scheme" {
      title = "scheme"
      type = "combo"
      width = 2
      option "https://" {}
      option "http://" {}
    }

    input "target_url" {
      title = "target url"
      type = "combo"
      width = 4
      option "steampipe.io" {}
    }

    table "links" {
      args = [ 
        self.input.scheme.value,
        self.input.target_url.value 
      ]
      query = query.links
      column "link" {
        href = "${local.host}/steampipe_stats.dashboard.Links?input.scheme={{.'scheme'}}&input.target_url={{.'link'}}"
        wrap = "all"
      }
      column "context" {
        wrap = "all"
      }
      column "response_error" {
        wrap = "all"
      }

    }

  }

}

query "links" {
  sql = <<EOQ
    with html as (
      select 
        response_body
      from
        net_http_request
      where
        url = $1 || $2
    ),
    link_contexts as (
      select
        (regexp_matches(response_body, '.{40,40} href="[^"]+".{40,40}', 'g'))[1] as context
      from
        html
    ),
    raw_links as (
      select
        context,
        (regexp_match(context, ' href="([^"]+)"'))[1] as link
      from
        link_contexts
    ),
    normalized_links as (
      select
        case 
          when left(link, 1) = '/' then $1 || (regexp_match($2, '[^/]+'))[1] || link
          else link
        end as link,
        context
      from
        raw_links
    ),
    http_links as (
      select
        *
      from 
        normalized_links
      where
        left(link, 4) = 'http'
      order by 
        link
    )
    select
      $2 as target,
      regexp_replace(h.link, 'http[s]*://', '') as link,
      regexp_match(h.link, 'http[s]*://') as scheme,
      n.response_status_code,
      n.response_error,
      h.context
    from 
      http_links h
    join 
      net_http_request n 
    on 
      h.link = n.url
    order by
      n.response_status_code desc
  EOQ
  param "scheme" {}
  param "target_url" {}
}


