defmodule HNAggregator.TopStories.PubSub.State do
  @moduledoc """
  Module to define the state of the `HNAggregator.PubSub` process as well as
  functions to interact with such state.
  """

  @type listener :: {Process.dest(), reference()}
  @type t :: %__MODULE__{
          listeners: list(listener())
        }

  @enforce_keys [:listeners]
  defstruct @enforce_keys

  @spec new() :: t()
  def new do
    %__MODULE__{
      listeners: []
    }
  end

  @spec subscribe(t(), Process.dest()) :: t()
  def subscribe(%__MODULE__{} = state, process) do
    already_subscribed? = Enum.any?(state.listeners, fn {listener, _} -> process == listener end)

    if already_subscribed? do
      state
    else
      monitor_ref = Process.monitor(process)
      new_listener = {process, monitor_ref}

      %{state | listeners: [new_listener | state.listeners]}
    end
  end

  @spec unsubscribe(t(), reference()) :: t()
  def unsubscribe(%__MODULE__{} = state, reference) do
    listeners =
      Enum.reject(state.listeners, fn {_process, monitor_ref} -> monitor_ref == reference end)

    %{state | listeners: listeners}
  end

  @spec publish(t(), term()) :: t()
  def publish(%__MODULE__{} = state, data) do
    Enum.each(state.listeners, fn {process, _} ->
      send(process, {:pub_sub, {:message, data}})
    end)

    state
  end

  @spec listeners(t()) :: list(Process.dest())
  def listeners(%__MODULE__{} = state) do
    Enum.map(state.listeners, fn {process, _} -> process end)
  end
end
