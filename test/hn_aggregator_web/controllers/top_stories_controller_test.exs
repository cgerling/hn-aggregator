defmodule HNAggregatorWeb.TopStoriesControllerTest do
  use HNAggregatorWeb.ConnCase, async: true

  alias HNAggregator.Factory
  alias HNAggregator.TopStories.PubSub

  setup do
    top_stories = Enum.map(1..50, fn id -> Factory.build(:item, id: id, type: "story") end)
    PubSub.publish(top_stories)

    on_exit(fn -> PubSub.publish([]) end)

    :ok
  end

  describe "GET /top-stories" do
    test "should return a list of stories", %{conn: conn} do
      assert response =
               conn
               |> get(Routes.top_stories_path(conn, :index))
               |> json_response(:ok)

      expected_keys = ["by", "descendants", "id", "score", "time", "title", "url"]
      assert Enum.all?(response, &(Map.keys(&1) == expected_keys))
    end

    test "should return a list with the stories of the first page", %{conn: conn} do
      assert response =
               conn
               |> get(Routes.top_stories_path(conn, :index))
               |> json_response(:ok)

      expected_ids = Enum.to_list(1..10)

      assert Enum.count(response) == 10
      assert Enum.map(response, & &1["id"]) == expected_ids
    end

    test "should return a list with the stories of the given page", %{conn: conn} do
      page = Enum.random(2..5)

      assert response =
               conn
               |> get(Routes.top_stories_path(conn, :index), page: page)
               |> json_response(:ok)

      offset = (page - 1) * 10
      expected_ids = Enum.map(1..10, &(offset + &1))

      assert Enum.count(response) == 10
      assert Enum.map(response, & &1["id"]) == expected_ids
    end

    test "should return an empty list when there is no stories at the given page", %{conn: conn} do
      assert response =
               conn
               |> get(Routes.top_stories_path(conn, :index), page: 6)
               |> json_response(:ok)

      assert response == []
    end
  end

  describe "GET /top-stories/:id" do
    test "should return a story with the given id", %{conn: conn} do
      id = Enum.random(1..50)

      assert response =
               conn
               |> get(Routes.top_stories_path(conn, :show, id))
               |> json_response(:ok)

      expected_keys = ["by", "descendants", "id", "score", "time", "title", "url"]
      assert response["id"] == id
      assert Map.keys(response) == expected_keys
    end

    test "should return a not found error when no story with the given id was found", %{
      conn: conn
    } do
      id = 51

      assert response =
               conn
               |> get(Routes.top_stories_path(conn, :show, id))
               |> json_response(:not_found)

      assert response["message"] == "Not Found"
    end
  end
end
