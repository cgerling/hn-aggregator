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

  describe "all_stories/0" do
    test "should return all present stories" do
      stories = TopStories.all_stories()

      assert stories == @top_stories
    end
  end

  describe "all/1" do
    test "should return stories paginated with the given limit and offset" do
      stories = TopStories.all_stories(limit: 2, offset: 4)

      assert stories == Enum.slice(@top_stories, 4, 2)
    end
  end

  describe "get_story/1" do
    test "should return a story with the given id" do
      id = :rand.uniform(10)
      story = TopStories.get_story(id)

      assert %Item{} = story
      assert story == Enum.at(@top_stories, id - 1)
    end

    test "should return nil when no story has the given id" do
      id = 11
      story = TopStories.get_story(id)

      assert is_nil(story)
    end
  end

  describe "update_stories/1" do
    test "should send a message to all registered watchers" do
      TopStories.watch_stories()

      stories = @top_stories
      assert TopStories.update_stories(stories) == :ok
      assert_receive {:watch, {:top_stories, ^stories}}
    end
  end

  describe "watch_stories/0" do
    test "should register current process as a watcher" do
      assert {:ok, watch_ref} = TopStories.watch_stories()
      assert is_reference(watch_ref)

      watchers = TopStories.watchers()

      assert Enum.any?(watchers, &(&1 == self()))
    end
  end

  describe "unwatch_stories/1" do
    test "should remove current process as a watcher" do
      {:ok, watch_ref} = TopStories.watch_stories()
      assert :ok == TopStories.unwatch_stories(watch_ref)

      watchers = TopStories.watchers()
      refute Enum.any?(watchers, &(&1 == self()))
    end
  end

  describe "watchers/0" do
    test "should return all processes registered as watchers" do
      watch_fn = fn ->
        TopStories.watch_stories()
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
