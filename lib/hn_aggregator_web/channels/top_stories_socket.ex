defmodule HNAggregatorWeb.TopStoriesSocket do
  @behaviour Phoenix.Socket.Transport

  alias HNAggregator.TopStories
  alias HNAggregatorWeb.TopStoriesView
  alias Phoenix.Socket.Transport

  @impl Transport
  def child_spec(_options) do
    %{id: __MODULE__, start: {Task, :start_link, [fn -> :ok end]}, restart: :transient}
  end

  @impl Transport
  def connect(transport_info) do
    {:ok, transport_info}
  end

  @impl Transport
  def init(_state) do
    {:ok, watch_ref} = TopStories.watch()

    TopStories.all()
    |> push()

    {:ok, %{watch_ref: watch_ref}}
  end

  @impl Transport
  def handle_in(_message, state) do
    {:ok, state}
  end

  @impl Transport
  def handle_info({:watch, {:top_stories, top_stories}}, state) do
    push(top_stories)

    {:ok, state}
  end

  def handle_info({:push, top_stories}, state) do
    message =
      "index.json"
      |> TopStoriesView.render(%{top_stories: top_stories})
      |> Jason.encode!()

    {:push, {:text, message}, state}
  end

  def handle_info(_message, state) do
    {:ok, state}
  end

  defp push(top_stories) do
    send(self(), {:push, top_stories})
  end

  @impl Transport
  def terminate(_reason, state) do
    TopStories.unwatch(state.watch_ref)
    :ok
  end
end
