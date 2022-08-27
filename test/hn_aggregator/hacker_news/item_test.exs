defmodule HNAggregator.HackerNews.ItemTest do
  use ExUnit.Case, async: true

  alias HNAggregator.Factory
  alias HNAggregator.HackerNews.Item

  describe "from_data/1" do
    test "should return an ok with an item when map is valid" do
      data = Factory.params_for(:item)
      data = %{data | "time" => DateTime.to_unix(data["time"])}

      assert {:ok, item = %Item{}} = Item.from_data(data)
      assert item.by == data["by"]
      assert item.descendants == data["descendants"]
      assert item.id == data["id"]
      assert item.score == data["score"]
      assert item.time == DateTime.from_unix!(data["time"])
      assert item.title == data["title"]
      assert item.type == data["type"]
      assert item.url == data["url"]
    end

    test "should return an error when time field is nil" do
      data = Factory.params_for(:item)
      data = %{data | "time" => nil}

      assert {:error, reason} = Item.from_data(data)
      assert reason == :invalid_time
    end

    test "should return an error when time field is invalid" do
      data = Factory.params_for(:item)
      data = %{data | "time" => 253_402_300_800}

      assert {:error, reason} = Item.from_data(data)
      assert reason == :invalid_unix_time
    end

    test "should return an error when data is invalid" do
      data = nil

      assert {:error, reason} = Item.from_data(data)
      assert reason == :invalid_data
    end
  end

  describe "is_story?/1" do
    test "should return true when item is a story" do
      item = Factory.build(:item, type: "story")

      assert Item.is_story?(item)
    end

    test "should return false when item is not a story" do
      not_story_types = ["job", "comment", "poll", "pollpot"]

      for type <- not_story_types do
        item = Factory.build(:item, type: type)

        refute Item.is_story?(item)
      end
    end
  end
end
