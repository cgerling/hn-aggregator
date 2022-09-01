defmodule HNAggregator.TopStories do
  @moduledoc """
  Context module to interact with the data fetched from HackerNews.
  """

  alias HNAggregator.HackerNews.Item

  @data_store HNAggregator.TopStories.DataStore
  @pub_sub HNAggregator.TopStories.PubSub

  @spec all_stories() :: list(Item.t())
  @spec all_stories(Keyword.t()) :: list(Item.t())
  def all_stories(options \\ []) when is_list(options) do
    GenServer.call(@data_store, {:all, options})
  end

  @spec get_story(pos_integer()) :: Item.t() | nil
  def get_story(id) when is_integer(id) and id > 0 do
    GenServer.call(@data_store, {:get, id})
  end

  @spec update_stories(list(Item.t())) :: :ok
  def update_stories(top_stories) when is_list(top_stories) do
    GenServer.call(@pub_sub, {:publish_change, top_stories})
  end

  @spec watch_stories() :: {:ok, reference}
  def watch_stories do
    GenServer.call(@pub_sub, :watch)
  end

  @spec unwatch_stories(reference()) :: :ok
  def unwatch_stories(watch_ref) when is_reference(watch_ref) do
    GenServer.call(@pub_sub, {:unwatch, watch_ref})
  end

  @spec watchers() :: list(Process.dest())
  def watchers do
    GenServer.call(@pub_sub, :watchers)
  end
end
