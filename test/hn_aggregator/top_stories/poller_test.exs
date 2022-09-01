defmodule HNAggregator.TopStories.PollerTest do
  use ExUnit.Case, async: false

  import Mox

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews
  alias HNAggregator.TopStories
  alias HNAggregator.TopStories.Poller

  setup do
    hacker_news_mod = Application.get_env(:hn_aggregator, :hacker_news)

    Application.put_env(:hn_aggregator, :hacker_news, HNAggregator.HackerNews.Mock)

    on_exit(fn -> Application.put_env(:hn_aggregator, :hacker_news, hacker_news_mod) end)
  end

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "should send a update message with the new top stories to the configured target",
       context do
    top_stories = Enum.map(1..10, &Factory.build(:item, id: &1, type: "story"))

    expect(HackerNews.Mock, :top_stories, 1, fn ->
      top_stories = Enum.to_list(1..10)
      {:ok, top_stories}
    end)

    expect(HackerNews.Mock, :item, 10, fn id ->
      item = Enum.at(top_stories, id - 1)
      {:ok, item}
    end)

    TopStories.watch_stories()

    start_supervised!({Poller, name: context.test})

    assert_receive {:watch, {:top_stories, _}}
  end

  test "should fetch new top stories after the configured rate interval", context do
    expect(HackerNews.Mock, :top_stories, 2, fn ->
      top_stories = Enum.to_list(1..10)
      {:ok, top_stories}
    end)

    expect(HackerNews.Mock, :item, 20, fn id ->
      item = Factory.build(:item, id: id, type: "story")
      {:ok, item}
    end)

    TopStories.watch_stories()

    rate = 200
    start_supervised!({Poller, name: context.test, rate: rate})

    assert_receive {:watch, {:top_stories, _}}

    Process.sleep(rate)

    assert_receive {:watch, {:top_stories, _}}
  end
end
