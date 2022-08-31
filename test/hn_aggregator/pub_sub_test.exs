defmodule HNAggregator.PubSubTest do
  use ExUnit.Case, async: false

  alias HNAggregator.PubSub

  describe "subscribe/0" do
    test "should register current process as a listener" do
      assert :ok == PubSub.subscribe()

      listeners = PubSub.listeners()

      assert Enum.any?(listeners, &(&1 == self()))
    end
  end

  describe "publish/1" do
    test "should send a message to all registered listeners" do
      PubSub.subscribe()

      assert PubSub.publish("test message") == :ok
      assert_receive {:pub_sub, {:message, "test message"}}
    end
  end

  describe "listeners/0" do
    test "should return all processes registered as listeners" do
      subscribe_fn = fn ->
        PubSub.subscribe()
        Process.sleep(1000)
      end

      process_a = spawn(subscribe_fn)
      process_b = spawn(subscribe_fn)

      Process.sleep(50)

      listeners = PubSub.listeners()
      assert Enum.any?(listeners, &(&1 == process_a))
      assert Enum.any?(listeners, &(&1 == process_b))

      Process.exit(process_a, :kill)
      Process.exit(process_b, :kill)
    end
  end
end
