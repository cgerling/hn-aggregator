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
    Logger.info("Fetching current top stories from Hacker News")

    {elapsed_time, state} = :timer.tc(State, :fetch_data, [state])

    Logger.info("Fetching process finished after #{to_seconds(elapsed_time)} secs")

    {:noreply, state}
  end

  def handle_info(_message, state) do
    {:noreply, state}
  end

  defp to_seconds(microseconds_time) do
    seconds_time = microseconds_time / 1_000_000

    Float.round(seconds_time, 2)
  end
end
