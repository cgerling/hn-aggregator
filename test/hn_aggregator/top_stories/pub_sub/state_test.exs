defmodule HNAggregator.TopStories.PubSub.StateTest do
  use ExUnit.Case, async: true

  alias HNAggregator.TopStories.PubSub.State

  describe "new/0" do
    test "should return a state struct with default values" do
      state = State.new()

      assert %State{} = state
      assert state.listeners == []
    end
  end

  describe "subscribe/2" do
    test "should return a new state with the given process as a listener" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      state = State.subscribe(state, process)

      assert [{listener, monitor_ref}] = state.listeners
      assert listener == process
      assert is_reference(monitor_ref)
    end

    test "should create a monitor reference off the given process" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      State.subscribe(state, process)

      assert Process.info(process, :monitored_by) == {:monitored_by, [self()]}
    end

    test "should not create duplicated entries when process tries to subscribe more than once" do
      state = State.new()
      process = spawn(fn -> Process.sleep(1000) end)

      state =
        state
        |> State.subscribe(process)
        |> State.subscribe(process)

      assert State.listeners(state) == [process]
    end
  end

  describe "unsubscribe/2" do
    test "should return a new state with the given process removed from listeners" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      state = State.subscribe(state, process)

      [{_, monitor_ref}] = state.listeners
      state = State.unsubscribe(state, monitor_ref)

      assert state.listeners == []
    end
  end

  describe "publish/2" do
    test "should send a message for all current listeners" do
      state = State.new()
      process = self()
      state = State.subscribe(state, process)

      State.publish(state, "test message")

      assert_received {:pub_sub, {:message, "test message"}}
    end
  end

  describe "listeners/1" do
    test "should return a list with all processes registered as listeners" do
      state = State.new()
      process = self()
      state = State.subscribe(state, process)

      assert State.listeners(state) == [process]
    end
  end
end
