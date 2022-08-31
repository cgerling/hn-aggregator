import Config

if System.get_env("SERVER") do
  config :hn_aggregator, HNAggregatorWeb.Endpoint, server: true
end

if config_env() == :prod do
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :hn_aggregator, HNAggregatorWeb.Endpoint,
    http: [
      port: port
    ]
end
