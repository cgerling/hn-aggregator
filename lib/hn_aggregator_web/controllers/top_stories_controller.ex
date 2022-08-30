defmodule HNAggregatorWeb.TopStoriesController do
  use HNAggregatorWeb, :controller

  alias HNAggregator.TopStories

  @page_size 10

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, params) do
    page = params |> Map.get("page", "1") |> String.to_integer()
    offset = (page - 1) * @page_size
    top_stories = TopStories.all(limit: @page_size, offset: offset)

    conn
    |> put_status(:ok)
    |> render("index.json", top_stories: top_stories)
  end
  end
end
