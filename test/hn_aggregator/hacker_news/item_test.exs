defmodule HNAggregator.HackerNews.ItemTest do
  use ExUnit.Case, async: true

  alias HNAggregator.HackerNews.Item

  describe "from_data/1" do
    test "should return an ok with an item when map is valid" do
      data = %{
        "by" => "author#{:rand.uniform(1000)}",
        "descendants" => :rand.uniform(1000),
        "id" => :rand.uniform(1_000_000),
        "score" => :rand.uniform(1000),
        "time" => DateTime.utc_now() |> DateTime.to_unix(),
        "title" => "Hacker News Item Title",
        "type" => Enum.random(["job", "story", "comment", "poll", "pollpot"]),
        "url" => "https://test.local/"
      }

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
      data = %{
        "by" => "author#{:rand.uniform(1000)}",
        "descendants" => :rand.uniform(1000),
        "id" => :rand.uniform(1_000_000),
        "score" => :rand.uniform(1000),
        "time" => nil,
        "title" => "Hacker News Item Title",
        "type" => Enum.random(["job", "story", "comment", "poll", "pollpot"]),
        "url" => "https://test.local/"
      }

      assert {:error, reason} = Item.from_data(data)
      assert reason == :invalid_time
    end

    test "should return an error when time field is invalid" do
      data = %{
        "by" => "author#{:rand.uniform(1000)}",
        "descendants" => :rand.uniform(1000),
        "id" => :rand.uniform(1_000_000),
        "score" => :rand.uniform(1000),
        "time" => 253_402_300_800,
        "title" => "Hacker News Item Title",
        "type" => Enum.random(["job", "story", "comment", "poll", "pollpot"]),
        "url" => "https://test.local/"
      }

      assert {:error, reason} = Item.from_data(data)
      assert reason == :invalid_unix_time
    end

    test "should return an error when data is invalid" do
      data = nil

      assert {:error, reason} = Item.from_data(data)
      assert reason == :invalid_data
    end
  end
end
