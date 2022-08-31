defmodule HNAggregator.TopStories.PubSub.ServerTest do
  use ExUnit.Case, async: true

  alias HNAggregator.TopStories.PubSub.Server
  alias HNAggregator.TopStories.PubSub.State

  setup context do
    name = context.test
    start_supervised!({Server, name: name})

    %{pub_sub: name}
  end

  test "should register client process as a listener", %{pub_sub: pub_sub} do
    GenServer.call(pub_sub, :subscribe)

    process = self()
    assert %State{listeners: [{^process, _monitor_ref}]} = :sys.get_state(pub_sub)
  end

  test "should send a message to all registered listeners", %{pub_sub: pub_sub} do
    GenServer.call(pub_sub, :subscribe)
    GenServer.call(pub_sub, {:publish, "test message"})

    assert_received {:pub_sub, {:message, "test message"}}
  end

  test "should return all processes registered as listeners", %{pub_sub: pub_sub} do
    subscribe_fn = fn ->
      GenServer.call(pub_sub, :subscribe)
      Process.sleep(1000)
    end

    process_a = spawn(subscribe_fn)
    process_b = spawn(subscribe_fn)

    Process.sleep(50)

    listeners = GenServer.call(pub_sub, :listeners)
    assert Enum.any?(listeners, &(&1 == process_a))
    assert Enum.any?(listeners, &(&1 == process_b))
  end

  test "should unsubscribe client process after it dies", %{pub_sub: pub_sub} do
    process =
      spawn(fn ->
        GenServer.call(pub_sub, :subscribe)
        Process.sleep(1000)
      end)

    Process.exit(process, :kill)

    Process.sleep(50)

    assert :sys.get_state(pub_sub) == State.new()
  end
end
