defmodule HNAggregator.TopStoriesTest do
  use ExUnit.Case, async: false

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews.Item
  alias HNAggregator.TopStories

  @top_stories Enum.map(1..10, &Factory.build(:item, id: &1, type: "story"))

  setup_all do
    TopStories.update_stories(@top_stories)

    on_exit(fn -> TopStories.update_stories([]) end)
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

  describe "update_stories/1" do
    test "should send a message to all registered watchers" do
      TopStories.watch()

      stories = @top_stories
      assert TopStories.update_stories(stories) == :ok
      assert_receive {:watch, {:top_stories, ^stories}}
    end
  end

  describe "watch/0" do
    test "should register current process as a watcher" do
      assert :ok == TopStories.watch()

      watchers = TopStories.watchers()

      assert Enum.any?(watchers, &(&1 == self()))
    end
  end

  describe "watchers/0" do
    test "should return all processes registered as watchers" do
      watch_fn = fn ->
        TopStories.watch()
        Process.sleep(1000)
      end

      process_a = spawn(watch_fn)
      process_b = spawn(watch_fn)

      Process.sleep(50)

      watchers = TopStories.watchers()
      assert Enum.any?(watchers, &(&1 == process_a))
      assert Enum.any?(watchers, &(&1 == process_b))

      Process.exit(process_a, :kill)
      Process.exit(process_b, :kill)
    end
  end
end
