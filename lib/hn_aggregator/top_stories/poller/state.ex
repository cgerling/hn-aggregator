defmodule HNAggregator.TopStories.Poller.State do
  @moduledoc """
  Module to define the state of the `HNAggregator.TopStories.Poller` process
  as well as functions to interact with such state.
  """

  alias HNAggregator.HackerNews
  alias HNAggregator.TopStories

  @type t :: %__MODULE__{
          rate: pos_integer()
        }

  @enforce_keys [:rate]
  defstruct @enforce_keys

  @default_rate 5 * 60 * 1000

  @spec new(Keyword.t()) :: t()
  def new(params) when is_list(params) do
    rate = Keyword.get(params, :rate, @default_rate)

    %__MODULE__{
      rate: rate
    }
  end

  @spec fetch_data(t()) :: t()
  def fetch_data(%__MODULE__{} = state) do
    HackerNews.top_stories()
    |> TopStories.update_stories()

    Process.send_after(self(), :fetch_data, state.rate)

    state
  end
end
