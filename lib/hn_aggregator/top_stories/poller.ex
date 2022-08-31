defmodule HNAggregator.TopStories.Poller do
  @moduledoc """
  GenServer responsible for polling the top stories data from HackerNews
  periodically and sending to `HNAggregator.TopStories.DataStore` process.

  ## Options
  * name - defines the name of the process
  * rate - defined the interval rate that the pull operation occurs in
  milliseconds, when not specified the default interval is 5 minutes
  """

  use GenServer

  alias HNAggregator.TopStories.Poller.State

  require Logger

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(options) do
    name = Keyword.get(options, :name, __MODULE__)

    GenServer.start_link(__MODULE__, options, name: name)
  end

  @impl GenServer
  def init(options) do
    send(self(), :fetch_data)

    state = State.new(options)
    {:ok, state}
  end

  @impl GenServer
  def handle_info(:fetch_data, state) do
    State.fetch_data(state)

    {:noreply, state}
  end

  def handle_info(message, state) do
    Logger.info("#{__MODULE__} received an unexpected message: #{inspect(message)}")

    {:noreply, state}
  end
end
