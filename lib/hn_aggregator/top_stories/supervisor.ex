defmodule HNAggregator.TopStories.Supervisor do
  use Supervisor

  alias HNAggregator.Pool
  alias HNAggregator.TopStories

  @spec start_link(term()) :: Supervisor.on_start()
  def start_link(_) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl Supervisor
  def init(_) do
    children = [
      TopStories.PubSub,
      TopStories.Poller,
      {Pool.Supervisor,
       worker: {TopStories.DataStore, name: nil}, size: 5, name: TopStories.DataStore.Pool}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
