defmodule HNAggregator.TopStories.PubSubTest do
  use ExUnit.Case, async: true

  alias HNAggregator.TopStories.PubSub
  alias HNAggregator.TopStories.PubSub.State

  setup context do
    name = context.test
    start_supervised!({PubSub, name: name})

    %{pub_sub: name}
  end

  test "should register client process as a watcher", %{pub_sub: pub_sub} do
    GenServer.call(pub_sub, :watch)

    process = self()
    assert %State{watchers: [{^process, _monitor_ref}]} = :sys.get_state(pub_sub)
  end

  test "should remove client from wathers list", %{pub_sub: pub_sub} do
    spawn(fn ->
      {:ok, watch_ref} = GenServer.call(pub_sub, :watch)
      GenServer.call(pub_sub, {:unwatch, watch_ref})
      Process.sleep(1000)
    end)

    Process.sleep(50)

    assert :sys.get_state(pub_sub) == State.new()
  end

  test "should send a message to all registered watchers", %{pub_sub: pub_sub} do
    GenServer.call(pub_sub, :watch)
    GenServer.call(pub_sub, {:publish_change, "test message"})

    assert_received {:watch, {:top_stories, "test message"}}
  end

  test "should return all processes registered as watchers", %{pub_sub: pub_sub} do
    subscribe_fn = fn ->
      GenServer.call(pub_sub, :watch)
      Process.sleep(1000)
    end

    process_a = spawn(subscribe_fn)
    process_b = spawn(subscribe_fn)

    Process.sleep(50)

    watchers = GenServer.call(pub_sub, :watchers)
    assert Enum.any?(watchers, &(&1 == process_a))
    assert Enum.any?(watchers, &(&1 == process_b))
  end

  test "should unsubscribe client process after it dies", %{pub_sub: pub_sub} do
    process =
      spawn(fn ->
        GenServer.call(pub_sub, :watch)
        Process.sleep(1000)
      end)

    Process.exit(process, :kill)

    Process.sleep(50)

    assert :sys.get_state(pub_sub) == State.new()
  end
end
