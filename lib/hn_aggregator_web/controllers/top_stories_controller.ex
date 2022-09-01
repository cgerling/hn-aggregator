defmodule HNAggregatorWeb.TopStoriesController do
  use HNAggregatorWeb, :controller

  alias HNAggregator.HackerNews.Item
  alias HNAggregator.TopStories

  action_fallback HNAggregatorWeb.TopStoriesFallbackController

  @page_size 10

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    page = params |> Map.get("page", "1") |> String.to_integer()
    offset = (page - 1) * @page_size
    top_stories = TopStories.all_stories(limit: @page_size, offset: offset)

    conn
    |> put_status(:ok)
    |> render("index.json", top_stories: top_stories)
  end

  @spec show(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def show(conn, params) do
    id = params |> Map.fetch!("id") |> String.to_integer()

    with %Item{} = story <- TopStories.get_story(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", story: story)
    end
  end
end
