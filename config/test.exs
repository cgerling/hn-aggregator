import Config

config :hn_aggregator, :hacker_news, HNAggregator.HackerNewsStub

config :hn_aggregator, HNAggregatorWeb.Endpoint, server: false

config :tesla, adapter: Tesla.Mock

config :logger, level: :info
