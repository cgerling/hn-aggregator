defmodule HNAggregator.TopStories.PubSub do
  @moduledoc false

  use GenServer

  alias HNAggregator.TopStories.PubSub.State

  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(options) do
    name = Keyword.get(options, :name, __MODULE__)
    GenServer.start_link(__MODULE__, [], name: name)
  end

  @impl GenServer
  def init(_) do
    state = State.new()

    {:ok, state}
  end

  @impl GenServer
  def handle_call(:subscribe, {from_pid, _}, state) do
    state = State.subscribe(state, from_pid)

    {:reply, :ok, state}
  end

  def handle_call({:publish, data}, _from, state) do
    state = State.publish(state, data)

    {:reply, :ok, state}
  end

  def handle_call(:listeners, _from, state) do
    listeners = State.listeners(state)

    {:reply, listeners, state}
  end

  @impl GenServer
  def handle_info({:DOWN, reference, :process, _object, _reason}, state) do
    state = State.unsubscribe(state, reference)

    {:noreply, state}
  end
end
