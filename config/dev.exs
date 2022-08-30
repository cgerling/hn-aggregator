import Config

config :tesla, adapter: Tesla.Adapter.Hackney

config :hn_aggregator, HNAggregatorWeb.Endpoint, http: [ip: {127, 0, 0, 1}, port: 4000]
