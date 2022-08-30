defmodule HNAggregatorWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :hn_aggregator

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Phoenix.json_library()

  plug HNAggregatorWeb.Router
end
