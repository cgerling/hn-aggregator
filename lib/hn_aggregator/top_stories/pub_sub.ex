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
  def handle_call(:watch, {from_pid, _}, state) do
    {watch_ref, state} = State.watch(state, from_pid)
    reply = {:ok, watch_ref}

    {:reply, reply, state}
  end

  def handle_call({:publish_change, data}, _from, state) do
    state = State.publish_change(state, data)

    {:reply, :ok, state}
  end

  def handle_call(:watchers, _from, state) do
    watchers = State.watchers(state)

    {:reply, watchers, state}
  end

  @impl GenServer
  def handle_info({:DOWN, reference, :process, _object, _reason}, state) do
    state = State.unwatch(state, reference)

    {:noreply, state}
  end
end
