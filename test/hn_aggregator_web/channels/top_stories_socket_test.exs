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
  end

  describe "handle_in/2" do
    test "should ignore incoming messages" do
      reply = TopStoriesSocket.handle_in({:text, "incoming message"}, %{})

      assert reply == {:ok, %{}}
    end
  end

  describe "handle_info/2" do
    test "should send new stories to client when top stories are updated" do
      story = Factory.build(:item, type: "story")
      reply = TopStoriesSocket.handle_info({:watch, {:top_stories, [story]}}, %{})

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
