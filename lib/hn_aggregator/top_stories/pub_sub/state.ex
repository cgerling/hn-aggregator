defmodule HNAggregator.TopStories.PubSub.State do
  @type watcher :: {Process.dest(), reference()}
  @type t :: %__MODULE__{
          watchers: list(watcher())
        }

  @enforce_keys [:watchers]
  defstruct @enforce_keys

  @spec new() :: t()
  def new do
    %__MODULE__{
      watchers: []
    }
  end

  @spec watch(t(), Process.dest()) :: {reference(), t()}
  def watch(%__MODULE__{} = state, process) do
    watcher = Enum.find(state.watchers, fn {watcher, _} -> process == watcher end)

    if watcher != nil do
      {_, watch_ref} = watcher
      {watch_ref, state}
    else
      monitor_ref = Process.monitor(process)
      new_watcher = {process, monitor_ref}

      state = %{state | watchers: [new_watcher | state.watchers]}
      {monitor_ref, state}
    end
  end

  @spec unwatch(t(), reference()) :: t()
  def unwatch(%__MODULE__{} = state, reference) do
    find_process_by_ref = fn {_process, monitor_ref} -> monitor_ref == reference end

    watch = Enum.find(state.watchers, find_process_by_ref)

    unless watch == nil do
      {_, watch_ref} = watch
      Process.demonitor(watch_ref)
    end

    watchers = Enum.reject(state.watchers, find_process_by_ref)

    %{state | watchers: watchers}
  end

  @spec publish_change(t(), term()) :: t()
  def publish_change(%__MODULE__{} = state, data) do
    Enum.each(state.watchers, fn {process, _} ->
      send_change(process, data)
    end)

    state
  end

  @spec send_change(Process.dest(), term()) :: :ok
  defp send_change(process, data) do
    message = {:watch, {:top_stories, data}}

    send(process, message)

    :ok
  end

  @spec watchers(t()) :: list(Process.dest())
  def watchers(%__MODULE__{} = state) do
    Enum.map(state.watchers, fn {process, _} -> process end)
  end
end
