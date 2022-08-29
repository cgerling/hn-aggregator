import Config

config :hn_aggregator, :hacker_news, HNAggregator.HackerNewsStub

config :tesla, adapter: Tesla.Mock
