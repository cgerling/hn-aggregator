defmodule HNAggregatorWeb.TopStoriesFallbackController do
  use HNAggregatorWeb, :controller

  alias HNAggregatorWeb.ErrorView

  @spec call(Plug.Conn.t(), term()) :: Plug.Conn.t()
  def call(conn, nil) do
    id = conn.params["id"]

    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json", message: "No top story was found with id=#{id}")
  end
end
