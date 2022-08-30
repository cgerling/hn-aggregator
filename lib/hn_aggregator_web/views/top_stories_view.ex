defmodule HNAggregatorWeb.TopStoriesView do
  use HNAggregatorWeb, :view

  @spec render(String.t(), map()) :: term()
  def render("index.json", %{top_stories: top_stories}) do
    render_many(top_stories, __MODULE__, "show.json", as: :story)
  end

  def render("show.json", %{story: story}) do
    %{
      by: story.by,
      descendants: story.descendants,
      id: story.id,
      score: story.score,
      time: story.time,
      title: story.title,
      url: story.url
    }
  end
end
