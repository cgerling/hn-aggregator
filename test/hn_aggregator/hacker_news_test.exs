defmodule HNAggregator.HackerNewsTest do
  use ExUnit.Case, async: true

  import Mox

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews
  alias HNAggregator.HackerNews.Item

  defmock(HackerNews.Mock, for: HackerNews.Behaviour)

  describe "top_stories/0" do
    test "should return a list with stories from the top stories" do
      top_stories_amount = 500

      expect(HackerNews.Mock, :top_stories, fn ->
        top_stories = Enum.map(1..top_stories_amount, fn _ -> :rand.uniform(1_000_000) end)

        {:ok, top_stories}
      end)

      expect(HackerNews.Mock, :item, top_stories_amount, fn id ->
        item = Factory.build(:item, id: id)

        {:ok, item}
      end)

      top_stories = HackerNews.top_stories()

      assert Enum.all?(top_stories, &match?(%Item{}, &1))
      assert Enum.all?(top_stories, &Item.is_story?/1)
    end

    test "should return a list with at most 50 stories from the top stories" do
      top_stories_amount = 500

      expect(HackerNews.Mock, :top_stories, fn ->
        top_stories = Enum.map(1..top_stories_amount, fn _ -> :rand.uniform(1_000_000) end)

        {:ok, top_stories}
      end)

      expect(HackerNews.Mock, :item, top_stories_amount, fn id ->
        item = Factory.build(:item, id: id, type: "story")

        {:ok, item}
      end)

      top_stories = HackerNews.top_stories()

      assert Enum.count(top_stories) == 50
    end

    test "should return an empty list when an error occurred while fetching the top stories" do
      expect(HackerNews.Mock, :top_stories, fn ->
        {:error, :something_went_wrong}
      end)

      top_stories = HackerNews.top_stories()

      assert top_stories == []
    end

    test "should return a list without the stories that could not be fetched" do
      top_stories_amount = 500

      expect(HackerNews.Mock, :top_stories, fn ->
        top_stories = Enum.map(1..top_stories_amount, fn _ -> :rand.uniform(1_000_000) end)

        {:ok, top_stories}
      end)

      expect(HackerNews.Mock, :item, top_stories_amount, fn _id ->
        {:error, :something_went_wrong}
      end)

      top_stories = HackerNews.top_stories()

      assert top_stories == []
    end
  end
end
