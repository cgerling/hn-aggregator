defmodule HNAggregator.TopStories.Poller.StateTest do
  use ExUnit.Case, async: true

  import Mox

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews
  alias HNAggregator.TopStories.Poller.State

  describe "new/1" do
    test "should return a state struct with default values" do
      state = State.new(target: TargetModule)

      assert %State{} = state
      assert state.target == TargetModule
      assert state.rate == 5 * 60 * 1000
    end

    test "should return a state struct with the given rate" do
      rate = :rand.uniform(10_000)
      state = State.new(target: TargetModule, rate: rate)

      assert %State{} = state
      assert state.target == TargetModule
      assert state.rate == rate
    end
  end

  describe "fetch_data/1" do
    setup do
      hacker_news_mod = Application.get_env(:hn_aggregator, :hacker_news)
      Application.put_env(:hn_aggregator, :hacker_news, HackerNews.Mock)

      on_exit(fn -> Application.put_env(:hn_aggregator, :hacker_news, hacker_news_mod) end)

      :ok
    end

    test "should send a update message with the fetched top stories to the configured target" do
      top_stories = Enum.map(1..10, &Factory.build(:item, id: &1, type: "story"))

      expect(HackerNews.Mock, :top_stories, 1, fn ->
        top_stories = Enum.to_list(1..10)
        {:ok, top_stories}
      end)

      expect(HackerNews.Mock, :item, 10, fn id ->
        item = Enum.at(top_stories, id - 1)
        {:ok, item}
      end)

      state = State.new(target: self())
      State.fetch_data(state)

      assert_receive {:update, ^top_stories}
    end
  end
end
