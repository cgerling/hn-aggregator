defmodule HNAggregator do
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      HNAggregator.TopStories.Supervisor
    ]

    opts = [strategy: :one_for_one, name: HNAggregator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
