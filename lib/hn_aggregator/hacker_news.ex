defmodule HNAggregator.HackerNews do
  @moduledoc "Entrypoint to interact with HackerNews remote API."

  alias HNAggregator.HackerNews.Item

  @spec top_stories() :: list(Item.t())
  def top_stories do
    case hacker_news().top_stories() do
      {:ok, top_stories} ->
        top_stories
        |> Enum.map(&hacker_news().item/1)
        |> Keyword.get_values(:ok)
        |> Enum.filter(&Item.is_story?/1)
        |> Enum.slice(0, 50)

      {:error, _} ->
        []
    end
  end

  @spec hacker_news() :: module()
  defp hacker_news do
    Application.fetch_env!(:hn_aggregator, :hacker_news)
  end
end
