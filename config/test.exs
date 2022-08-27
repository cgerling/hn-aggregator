import Config

config :hn_aggregator, :hacker_news, HNAggregator.HackerNews.Mock

config :tesla, adapter: Tesla.Mock
