defmodule HNAggregator.HackerNews.HTTP do
  @moduledoc "HTTP client to interact with the HackerNews API."

  @behaviour HNAggregator.HackerNews.Behaviour

  alias HNAggregator.HackerNews.Behaviour
  alias HNAggregator.HackerNews.Item
  alias HNAggregator.HTTP

  @base_url "https://hacker-news.firebaseio.com/v0"

  @impl Behaviour
  def top_stories do
    url = build_url("/topstories.json")

    with {:ok, response} <- HTTP.get(url) do
      parse_response(response)
    end
  end

  @impl Behaviour
  def item(id) when is_integer(id) and id > 0 do
    url = build_url("/item/#{id}.json")

    with {:ok, response} <- HTTP.get(url),
         {:ok, data} <- parse_response(response) do
      Item.from_data(data)
    end
  end

  @spec build_url(String.t()) :: String.t()
  defp build_url(path) do
    "#{@base_url}#{path}"
  end

  @spec parse_response(Tesla.Env.t()) :: {:ok, term()} | {:error, term()}
  defp parse_response(%Tesla.Env{status: status, body: body}) when status in 200..299 do
    {:ok, body}
  end

  defp parse_response(%Tesla.Env{body: body}) do
    {:error, body}
  end
end
