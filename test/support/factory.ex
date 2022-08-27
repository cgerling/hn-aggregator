defmodule HNAggregator.Factory do
  @moduledoc "Helper module to generate data for tests."

  alias HNAggregator.HackerNews.Item

  @type params :: %{binary() => term()}

  @spec build(atom(), Keyword.t()) :: struct()
  def build(:item, values \\ []) do
    default_by = "author#{:rand.uniform(1000)}"
    default_descendants = :rand.uniform(1000)
    default_id = :rand.uniform(1_000_000)
    default_score = :rand.uniform(1000)
    default_time = DateTime.utc_now() |> DateTime.truncate(:second)
    default_title = "Hacker News Item Title"
    default_type = Enum.random(["job", "story", "comment", "poll", "pollpot"])
    default_url = "https://test.local/"

    %Item{
      by: Keyword.get(values, :by, default_by),
      descendants: Keyword.get(values, :descendants, default_descendants),
      id: Keyword.get(values, :id, default_id),
      score: Keyword.get(values, :score, default_score),
      time: Keyword.get(values, :time, default_time),
      title: Keyword.get(values, :title, default_title),
      type: Keyword.get(values, :type, default_type),
      url: Keyword.get(values, :url, default_url)
    }
  end

  @spec params_for(atom(), Keyword.t()) :: params()
  def params_for(name, values \\ []) do
    name
    |> build(values)
    |> to_params()
  end

  @spec to_params(struct()) :: params()
  def to_params(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> Map.new(&atom_key_to_string/1)
  end

  @spec atom_key_to_string({atom(), term()}) :: {binary(), term()}
  defp atom_key_to_string({key, value}), do: {Atom.to_string(key), value}
end
