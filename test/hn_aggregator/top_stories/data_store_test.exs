defmodule HNAggregator.TopStories.DataStoreTest do
  use ExUnit.Case, async: false

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews.Item
  alias HNAggregator.TopStories.DataStore
  alias HNAggregator.TopStories.DataStore.State
  alias HNAggregator.TopStories.PubSub

  setup context do
    name = context.test
    start_supervised!({DataStore, name: name})

    %{data_store: name}
  end

  test "should save into its state the data coming from the pub sub", %{data_store: data_store} do
    top_stories = Enum.map(1..10, fn _ -> Factory.build(:item) end)
    PubSub.publish(top_stories)

    assert :sys.get_state(data_store) == State.new(top_stories)
  end

  test "should return all present stories", %{data_store: data_store} do
    top_stories = Enum.map(1..10, fn _ -> Factory.build(:item) end)
    PubSub.publish(top_stories)

    assert GenServer.call(data_store, {:all, []}) == top_stories
  end

  test "should return stories paginated with the given limit and offset", %{
    data_store: data_store
  } do
    top_stories = Enum.map(1..10, fn _ -> Factory.build(:item) end)
    PubSub.publish(top_stories)

    stories = GenServer.call(data_store, {:all, limit: 4, offset: 6})
    assert stories == Enum.slice(top_stories, 6, 4)
  end

  test "should return a story with the given id", %{data_store: data_store} do
    top_stories = Enum.map(1..10, &Factory.build(:item, id: &1))
    PubSub.publish(top_stories)

    id = :rand.uniform(10)
    story = GenServer.call(data_store, {:get, id})

    assert %Item{} = story
    assert story.id == id
  end

  test "should return nil when no story has the given id", %{data_store: data_store} do
    top_stories = []
    PubSub.publish(top_stories)

    id = :rand.uniform(10)
    story = GenServer.call(data_store, {:get, id})

    assert is_nil(story)
  end
end
