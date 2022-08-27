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
end
