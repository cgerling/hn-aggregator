defmodule HNAggregator.TopStories.Poller.State do
  @moduledoc """
  Module to define the state of the `HNAggregator.TopStories.Poller` process
  as well as functions to interact with such state.
  """

  @type t :: %__MODULE__{
          target: Process.dest(),
          rate: pos_integer()
        }

  @enforce_keys [:target, :rate]
  defstruct @enforce_keys

  @default_rate 5 * 60 * 1000

  @spec new(Keyword.t()) :: t()
  def new(params) when is_list(params) do
    target = Keyword.fetch!(params, :target)
    rate = Keyword.get(params, :rate, @default_rate)

    %__MODULE__{
      target: target,
      rate: rate
    }
  end
end
