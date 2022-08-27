defmodule HNAggregator.HackerNews.HTTPTest do
  use ExUnit.Case, async: true

  import Tesla.Mock

  alias HNAggregator.HackerNews
  alias HNAggregator.HackerNews.HTTP
  alias HNAggregator.HackerNews.Item

  setup_all do
    Hammox.protect(HTTP, HackerNews.Behaviour)
  end

  describe "top_stories/0" do
    test "should return a list with all the current top stories", %{top_stories_0: top_stories_0} do
      mock(fn _ ->
        body = Enum.map(1..100, fn _ -> :rand.uniform(1000) end)
        %Tesla.Env{status: 200, body: body}
      end)

      assert {:ok, top_stories} = top_stories_0.()
      assert Enum.all?(top_stories, &(is_integer(&1) and &1 > 0))
    end

    test "should return an error when something goes wrong", %{top_stories_0: top_stories_0} do
      mock(fn _ ->
        status = Enum.random(400..599)
        body = %{message: "Something went wrong"}
        %Tesla.Env{status: status, body: body}
      end)

      assert {:error, reason} = top_stories_0.()
      assert reason == %{message: "Something went wrong"}
    end
  end

  describe "item/1" do
    test "should return all properties of a item with the given id", %{item_1: item_1} do
      by = "author#{:rand.uniform(1000)}"
      descendants = :rand.uniform(1000)
      id = :rand.uniform(1_000_000)
      score = :rand.uniform(1000)
      time = DateTime.utc_now() |> DateTime.truncate(:second)
      title = "Hacker News Item Title"
      type = Enum.random(["job", "story", "comment", "poll", "pollpot"])
      url = "https://test.local/"

      mock(fn _ ->
        body = %{
          "by" => by,
          "descendants" => descendants,
          "id" => id,
          "score" => score,
          "time" => DateTime.to_unix(time),
          "title" => title,
          "type" => type,
          "url" => url
        }

        %Tesla.Env{status: 200, body: body}
      end)

      assert {:ok, %Item{} = item} = item_1.(id)
      assert item.by == by
      assert item.descendants == descendants
      assert item.id == id
      assert item.score == score
      assert item.time == time
      assert item.title == title
      assert item.type == type
      assert item.url == url
    end

    test "should return an error when something goes wrong", %{item_1: item_1} do
      mock(fn _ ->
        status = Enum.random(400..599)
        body = %{message: "Something went wrong"}
        %Tesla.Env{status: status, body: body}
      end)

      id = :rand.uniform(1_000_000)
      assert {:error, reason} = item_1.(id)
      assert reason == %{message: "Something went wrong"}
    end
  end
end
