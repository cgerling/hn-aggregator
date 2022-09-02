defmodule HNAggregator.HackerNewsStub do
  @behaviour HNAggregator.HackerNews.Behaviour

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews.Behaviour

  @impl Behaviour
  def top_stories, do: {:ok, []}

  @impl Behaviour
  def item(id), do: {:ok, Factory.build(:item, id: id)}
end
