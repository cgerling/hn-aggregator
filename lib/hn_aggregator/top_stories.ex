defmodule HNAggregator.TopStories do
  @moduledoc """
  Context module to interact with the data fetched from HackerNews.
  """

  alias HNAggregator.HackerNews.Item

  @server HNAggregator.TopStories.DataStore

  @spec all() :: list(Item.t())
  @spec all(Keyword.t()) :: list(Item.t())
  def all(options \\ []) when is_list(options) do
    GenServer.call(@server, {:all, options})
  end

  @spec get(pos_integer()) :: Item.t() | nil
  def get(id) when is_integer(id) and id > 0 do
    GenServer.call(@server, {:get, id})
  end
end
