defmodule HNAggregatorWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :hn_aggregator

  @timeout_10mins 10 * 60 * 1000

  socket "/top-stories", HNAggregatorWeb.TopStoriesSocket,
    websocket: [path: "/ws", timeout: @timeout_10mins]

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Phoenix.json_library()

  plug HNAggregatorWeb.Router
end
