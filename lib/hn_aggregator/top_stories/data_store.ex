defmodule HNAggregator.TopStories.DataStore do
  @moduledoc """
  GenServer responsible for storing the current HackerNews top stories.

  ## Options

  * name - defines the name of the process
  """

  use GenServer

  alias HNAggregator.TopStories
  alias HNAggregator.TopStories.DataStore.State

  require Logger

  @spec start_link(term()) :: GenServer.on_start()
  def start_link(options) do
    name = Keyword.get(options, :name, __MODULE__)
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @impl GenServer
  def init(_) do
    TopStories.watch_stories()
    state = State.new()

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:all, options}, _from, state) do
    top_stories = State.all(state, options)

    {:reply, top_stories, state}
  end

  def handle_call({:get, id}, _from, state) do
    story = State.get(state, id)

    {:reply, story, state}
  end

  @impl GenServer
  def handle_info({:watch, {:top_stories, top_stories}}, _state) do
    state = State.new(top_stories)

    {:noreply, state}
  end

  def handle_info(message, state) do
    Logger.info("#{__MODULE__} received message: #{inspect(message)}")

    {:noreply, state}
  end
end
