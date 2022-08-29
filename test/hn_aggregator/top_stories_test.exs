defmodule HNAggregator.TopStoriesTest do
  use ExUnit.Case, async: false

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews.Item
  alias HNAggregator.TopStories

  @top_stories Enum.map(1..10, &Factory.build(:item, id: &1, type: "story"))

  setup_all do
    send(TopStories.DataStore, {:update, @top_stories})

    on_exit(fn -> send(TopStories.DataStore, {:update, []}) end)
    :ok
  end

  describe "all/0" do
    test "should return all present stories" do
      stories = TopStories.all()

      assert stories == @top_stories
    end
  end

  describe "all/1" do
    test "should return stories paginated with the given limit and offset" do
      stories = TopStories.all(limit: 2, offset: 4)

      assert stories == Enum.slice(@top_stories, 4, 2)
    end
  end

  describe "get/1" do
    test "should return a story with the given id" do
      id = :rand.uniform(10)
      story = TopStories.get(id)

      assert %Item{} = story
      assert story == Enum.at(@top_stories, id - 1)
    end

    test "should return nil when no story has the given id" do
      id = 11
      story = TopStories.get(id)

      assert is_nil(story)
    end
  end
end
