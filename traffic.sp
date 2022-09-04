dashboard "Traffic" {

  tags = {
    service = "Steampipe Stats"
  }

  container {
    text {
      width = 6
      value = <<EOT
[Hacker News](${local.host}/steampipe_stats.dashboard.HackerNews)
🞄
[Mods](${local.host}/steampipe_stats.dashboard.Mods)
🞄
[News](${local.host}/steampipe_stats.dashboard.News)
🞄
[Repos](${local.host}/steampipe_stats.dashboard.Repos)
🞄
[Slack](${local.host}/steampipe_stats.dashboard.Slack)
🞄
[Stargazers](${local.host}/steampipe_stats.dashboard.Traffic)
🞄
Traffic
🞄
[Twitter](${local.host}/steampipe_stats.dashboard.Twitter)
      EOT
    }
  }

container {
	title = "plugins"
	
	chart {
	width = 2
	title = "turbot/aws"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-aws'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/sdk"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-sdk'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/azure"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-azure'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/github"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-github'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/gcp"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-gcp'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/kubernetes"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-kubernetes'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/azuread"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-azuread'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/pagerduty"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-pagerduty'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/csv"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-csv'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/office365"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-office365'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/terraform"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-terraform'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/salesforce"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-salesforce'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/googlesheets"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-googlesheets'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/alicloud"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-alicloud'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/hackernews"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-hackernews'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/oci"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-oci'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/slack"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-slack'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/code"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-code'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/jira"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-jira'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/imap"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-imap'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/awscfn"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-awscfn'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/net"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-net'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/okta"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-okta'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/ldap"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-ldap'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/bitbucket"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-bitbucket'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/abuseipdb"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-abuseipdb'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/config"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-config'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/shodan"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-shodan'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/finance"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-finance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/crowdstrike"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-crowdstrike'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/ibm"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-ibm'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/grafana"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-grafana'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/zoom"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-zoom'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/steampipecloud"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-steampipecloud'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/googleworkspace"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-googleworkspace'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/turbot"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-turbot'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/hypothesis"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-hypothesis'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/rss"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-rss'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/steampipe"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-steampipe'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/crtsh"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-crtsh'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/zendesk"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-zendesk'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/twitter"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-twitter'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/docker"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-docker'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/panos"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-panos'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/algolia"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-algolia'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/trivy"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-trivy'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/prometheus"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-prometheus'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/snowflake"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-snowflake'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/datadog"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-datadog'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/updown"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-updown'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/hcloud"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-hcloud'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/virustotal"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-virustotal'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/digitalocean"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-digitalocean'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/ipstack"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-ipstack'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/googledirectory"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-googledirectory'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/chaos"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-chaos'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/heroku"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-heroku'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/mongodbatlas"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-mongodbatlas'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/twilio"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-twilio'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/planetscale"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-planetscale'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/whois"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-whois'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/tfe"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-tfe'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/equinix"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-equinix'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/stripe"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-stripe'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/urlscan"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-urlscan'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/buildkite"
	axes {
		y {
			max = 46
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-plugin-buildkite'
		order by
		timestamp;    
	EOT
	}

}

container {
	title = "mods"
	
	chart {
	width = 2
	title = "turbot/aws-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-aws-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/aws-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-aws-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/azure-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-azure-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/aws-perimeter"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-aws-perimeter'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/gcp-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-gcp-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/github-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-github-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/office365-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-office365-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/aws-thrifty"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-aws-thrifty'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/terraform-aws-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-terraform-aws-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/kubernetes-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-kubernetes-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/aws-tags"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-aws-tags'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/gcp-labels"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-gcp-labels'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/zoom-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-zoom-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/kubernetes-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-kubernetes-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/oci-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-oci-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/rss-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-rss-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/hackernews-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-hackernews-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/gcp-thrifty"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-gcp-thrifty'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/azure-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-azure-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/github-sherlock"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-github-sherlock'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/gcp-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-gcp-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/snowflake-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-snowflake-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/terraform-azure-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-terraform-azure-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/oci-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-oci-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/terraform-oci-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-terraform-oci-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/gitlab-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-gitlab-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/aws-top10"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-aws-top10'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/alicloud-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-alicloud-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/oci-thrifty"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-oci-thrifty'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/awscfn-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-awscfn-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/terraform-gcp-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-terraform-gcp-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/ibm-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-ibm-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/ibm-compliance"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-ibm-compliance'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/digitalocean-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-digitalocean-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/azure-tags"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-azure-tags'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/finance-insights"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-finance-insights'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/jira-sherlock"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-jira-sherlock'
		order by
		timestamp;    
	EOT
	}

	chart {
	width = 2
	title = "turbot/jira-thrifty"
	axes {
		y {
			max = 31
		}
		}
	sql = <<EOT
		select
		to_char(timestamp, 'MM-DD'),
		uniques
		from
		github_traffic_view_daily
		where
		repository_full_name = 'turbot/steampipe-mod-jira-thrifty'
		order by
		timestamp;    
	EOT
	}

}

}
	  