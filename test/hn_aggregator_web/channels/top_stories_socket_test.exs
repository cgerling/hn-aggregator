defmodule HNAggregatorWeb.TopStoriesSocketTest do
  use ExUnit.Case, async: true

  alias HNAggregator.Factory
  alias HNAggregator.TopStories
  alias HNAggregatorWeb.TopStoriesSocket

  describe "init/1" do
    test "should subscribe to pub sub" do
      assert {:ok, %{}} = TopStoriesSocket.init(%{})

      assert TopStories.watchers() |> Enum.any?(&(&1 == self()))
    end

    test "should send a push message to send current stories to client" do
      TopStoriesSocket.init(%{})

      assert_receive {:push, top_stories} when is_list(top_stories)
    end
  end

  describe "handle_in/2" do
    test "should ignore incoming messages" do
      reply = TopStoriesSocket.handle_in({:text, "incoming message"}, %{})

      assert reply == {:ok, %{}}
    end
  end

  describe "handle_info/2" do
    test "should send a push message to send new stories to client when top stories are updated" do
      story = Factory.build(:item, type: "story")
      TopStoriesSocket.handle_info({:pub_sub, {:message, [story]}}, %{})

      assert_receive {:push, [^story]}
    end

    test "should push message to client when receive push message" do
      story = Factory.build(:item, type: "story")
      reply = TopStoriesSocket.handle_info({:push, [story]}, %{})

      message =
        "[{\"by\":\"#{story.by}\",\"descendants\":#{story.descendants},\"id\":#{story.id},\"score\":#{story.score},\"time\":\"#{DateTime.to_iso8601(story.time)}\",\"title\":\"#{story.title}\",\"url\":\"#{story.url}\"}]"

      assert reply == {:push, {:text, message}, %{}}
    end

    test "should ignore received message" do
      reply = TopStoriesSocket.handle_info(:message, %{})

      assert reply == {:ok, %{}}
    end
  end
end
