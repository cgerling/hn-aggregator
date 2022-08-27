defmodule HNAggregator.HTTP do
  @moduledoc "A simple REST HTTP client"

  use Tesla

  plug(Tesla.Middleware.JSON)
end
