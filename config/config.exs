import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :hn_aggregator, :hacker_news, HNAggregator.HackerNews.HTTP

config :hn_aggregator, HNAggregatorWeb.Endpoint,
  render_errors: [view: HNAggregatorWeb.ErrorView, accepts: ~w(json)]

config :phoenix, :json_library, Jason

config :logger, :console, format: "$time [$level] $message\n"

import_config "#{config_env()}.exs"
