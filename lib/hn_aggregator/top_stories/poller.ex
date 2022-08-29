defmodule HNAggregator.TopStories.Poller do
  @moduledoc """
  GenServer responsible for polling the top stories data from HackerNews
  periodically and sending to `HNAggregator.TopStories.DataStore` process.

  ## Options
  * name - defines the name of the process
  * target - defines to which process the pulled data will be sent
  * rate - defined the interval rate that the pull operation occurs in
  milliseconds, when not specified the default interval is 5 minutes
  """

  use GenServer

  alias HNAggregator.HackerNews
  alias HNAggregator.TopStories.Poller.State

  require Logger

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(options) do
    name = Keyword.get(options, :name, __MODULE__)

    GenServer.start_link(__MODULE__, options, name: name)
  end

  @impl GenServer
  def init(options) do
    send(self(), :refresh)

    state = State.new(options)
    {:ok, state}
  end

  @impl GenServer
  def handle_info(:refresh, state) do
    top_stories = HackerNews.top_stories()

    send(state.target, {:update, top_stories})
    Process.send_after(self(), :refresh, state.rate)

    {:noreply, state}
  end

  def handle_info(message, state) do
    Logger.info("#{__MODULE__} received an unexpected message: #{inspect(message)}")

    {:noreply, state}
  end
end
