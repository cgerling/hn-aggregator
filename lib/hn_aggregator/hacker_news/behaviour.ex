defmodule HNAggregator.HackerNews.Behaviour do
  @moduledoc "Behaviour module to enforce an API for all Hacker News client implementations."

  alias HNAggregator.HackerNews.Item

  @type item_id :: pos_integer()

  @callback top_stories() :: {:ok, list(item_id())} | {:error, term()}
  @callback item(id :: item_id()) :: {:ok, Item.t()} | {:error, term()}
end
