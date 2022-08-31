defmodule HNAggregator.TopStories.Supervisor do
  @moduledoc false

  use Supervisor

  alias HNAggregator.TopStories

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl Supervisor
  def init(_) do
    children = [
      TopStories.PubSub.Server,
      TopStories.Poller,
      TopStories.DataStore
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
