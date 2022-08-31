defmodule HNAggregator.TopStories do
  @moduledoc """
  Context module to interact with the data fetched from HackerNews.
  """

  alias HNAggregator.HackerNews.Item

  @data_store HNAggregator.TopStories.DataStore
  @pub_sub HNAggregator.TopStories.PubSub.Server

  @spec all() :: list(Item.t())
  @spec all(Keyword.t()) :: list(Item.t())
  def all(options \\ []) when is_list(options) do
    GenServer.call(@data_store, {:all, options})
  end

  @spec get(pos_integer()) :: Item.t() | nil
  def get(id) when is_integer(id) and id > 0 do
    GenServer.call(@data_store, {:get, id})
  end

  @spec update_stories(list(Item.t())) :: :ok
  def update_stories(top_stories) when is_list(top_stories) do
    GenServer.call(@pub_sub, {:publish, top_stories})
  end

  @spec watch() :: :ok
  def watch do
    GenServer.call(@pub_sub, :subscribe)
  end

  @spec watchers() :: list(Process.dest())
  def watchers do
    GenServer.call(@pub_sub, :listeners)
  end
end
