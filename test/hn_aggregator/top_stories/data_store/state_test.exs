defmodule HNAggregator.TopStories.DataStore.StateTest do
  use ExUnit.Case, async: true

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews.Item
  alias HNAggregator.TopStories.DataStore.State

  describe "new/0" do
    test "should return a state struct with default values" do
      state = State.new()

      assert %State{} = state
      assert state.top_stories == []
    end
  end

  describe "new/1" do
    test "should return a state struct with the given top stories" do
      top_stories = Enum.map(1..10, fn _ -> Factory.build(:item) end)
      state = State.new(top_stories)

      assert %State{} = state
      assert state.top_stories == top_stories
    end
  end

  describe "all/2" do
    test "should return all present stories" do
      top_stories = Enum.map(1..10, fn _ -> Factory.build(:item) end)
      state = State.new(top_stories)

      stories = State.all(state, [])
      assert stories == top_stories
    end

    test "should return stories paginated with the given limit and offset" do
      top_stories = Enum.map(1..10, fn _ -> Factory.build(:item) end)
      state = State.new(top_stories)

      stories = State.all(state, limit: 4, offset: 6)
      assert stories == Enum.slice(top_stories, 6, 4)
    end
  end

  describe "get/2" do
    test "should return a story with the given id" do
      amount = 10
      top_stories = Enum.map(1..amount, &Factory.build(:item, id: &1))
      state = State.new(top_stories)

      id = :rand.uniform(amount)
      story = State.get(state, id)

      assert %Item{} = story
      assert story.id == id
    end

    test "should return nil when no story has the given id" do
      amount = 10
      top_stories = Enum.map(1..amount, &Factory.build(:item, id: &1))
      state = State.new(top_stories)

      id = :rand.uniform(amount) + amount
      story = State.get(state, id)

      assert is_nil(story)
    end
  end
end
