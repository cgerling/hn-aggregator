defmodule HNAggregator do
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      HNAggregator.TopStories.Supervisor,
      HNAggregatorWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: HNAggregator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def config_change(changed, _new, removed) do
    HNAggregatorWeb.Endpoint.config_change(changed, removed)

    :ok
  end
end
