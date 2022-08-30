defmodule HNAggregatorWeb.Router do
  use HNAggregatorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HNAggregatorWeb do
    pipe_through :api

    resources "/top-stories", TopStoriesController, only: [:index]
  end
end
