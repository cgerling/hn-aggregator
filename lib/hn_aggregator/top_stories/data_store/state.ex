defmodule HNAggregator.TopStories.DataStore.State do
  alias HNAggregator.HackerNews.Item

  @type t() :: %__MODULE__{
          top_stories: list(Item.t())
        }

  @enforce_keys [:top_stories]
  defstruct @enforce_keys

  @spec new() :: t()
  @spec new(list(Item.t())) :: t()
  def new(top_stories \\ []) do
    %__MODULE__{
      top_stories: top_stories
    }
  end

  @spec all(t(), Keyword.t()) :: list(Item.t())
  def all(%__MODULE__{top_stories: top_stories}, options) when is_list(options) do
    limit = Keyword.get_lazy(options, :limit, fn -> Enum.count(top_stories) end)
    offset = Keyword.get(options, :offset, 0)

    Enum.slice(top_stories, offset, limit)
  end

  @spec get(t(), pos_integer()) :: Item.t() | nil
  def get(%__MODULE__{top_stories: top_stories}, id) when is_integer(id) and id > 0 do
    Enum.find(top_stories, &(&1.id == id))
  end
end
