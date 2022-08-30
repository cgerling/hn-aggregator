defmodule HNAggregatorWeb.TopStoriesControllerTest do
  use HNAggregatorWeb.ConnCase, async: true

  alias HNAggregator.Factory

  setup do
    top_stories = Enum.map(1..50, fn id -> Factory.build(:item, id: id, type: "story") end)
    send(HNAggregator.TopStories.DataStore, {:update, top_stories})

    on_exit(fn -> send(HNAggregator.TopStories.DataStore, {:update, []}) end)

    :ok
  end

  describe "GET /top-stories" do
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
end
