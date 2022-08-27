import Config

config :hn_aggregator, :hacker_news, HNAggregator.HackerNews.HTTP

import_config "#{config_env()}.exs"
