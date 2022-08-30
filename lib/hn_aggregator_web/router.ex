defmodule HNAggregatorWeb.Router do
  use HNAggregatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HNAggregatorWeb do
    pipe_through :api
  end
end
