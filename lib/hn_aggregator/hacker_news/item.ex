defmodule HNAggregator.HackerNews.Item do
  @moduledoc "Base structure for asks, comments, jobs, polls, and stories."

  @type t :: %__MODULE__{
          by: String.t(),
          descendants: pos_integer(),
          id: pos_integer(),
          score: non_neg_integer(),
          time: DateTime.t(),
          title: String.t(),
          type: String.t(),
          url: String.t()
        }

  @enforce_keys [
    :by,
    :descendants,
    :id,
    :score,
    :time,
    :title,
    :type,
    :url
  ]
  defstruct @enforce_keys

  @spec from_data(term()) :: {:ok, t()} | {:error, atom()}
  def from_data(%{} = data) do
    with {:ok, time = %DateTime{}} <- parse_time(data["time"]) do
      item = %__MODULE__{
        by: data["by"],
        descendants: data["descendants"],
        id: data["id"],
        score: data["score"],
        time: time,
        title: data["title"],
        type: data["type"],
        url: data["url"]
      }

      {:ok, item}
    end
  end

  def from_data(_), do: {:error, :invalid_data}

  defp parse_time(time) when is_integer(time) do
    DateTime.from_unix(time)
  end

  defp parse_time(nil), do: {:error, :invalid_time}
end
