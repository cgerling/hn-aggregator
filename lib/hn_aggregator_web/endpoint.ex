defmodule HNAggregatorWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :hn_aggregator

  socket "/top-stories", HNAggregatorWeb.TopStoriesSocket, websocket: [path: "/ws"]

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Phoenix.json_library()

  plug HNAggregatorWeb.Router
end
