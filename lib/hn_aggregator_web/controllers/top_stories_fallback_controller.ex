defmodule HNAggregatorWeb.TopStoriesFallbackController do
  use HNAggregatorWeb, :controller

  alias HNAggregatorWeb.ErrorView

  @spec call(Plug.Conn.t(), term()) :: Plug.Conn.t()
  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json")
  end
end
