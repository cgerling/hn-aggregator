defmodule HNAggregator.TopStories.PubSub.StateTest do
  use ExUnit.Case, async: true

  alias HNAggregator.TopStories.PubSub.State

  describe "new/0" do
    test "should return a state struct with default values" do
      state = State.new()

      assert %State{} = state
      assert state.watchers == []
    end
  end

  describe "watch/2" do
    test "should return a reference a the new state with the given process as a watcher" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      {watch_ref, state} = State.watch(state, process)

      assert is_reference(watch_ref)
      assert [{watcher, monitor_ref}] = state.watchers
      assert watcher == process
      assert monitor_ref == watch_ref
    end

    test "should create a monitor reference off the given process" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      State.watch(state, process)

      assert Process.info(process, :monitored_by) == {:monitored_by, [self()]}
    end

    test "should not create duplicated entries when process tries to watch more than once" do
      state = State.new()
      process = spawn(fn -> Process.sleep(1000) end)

      {_, state} = State.watch(state, process)
      {_, state} = State.watch(state, process)

      assert State.watchers(state) == [process]
    end

    test "should send a message with the last published change" do
      state = State.new()
      state = State.publish_change(state, "last published change")

      State.watch(state, self())
      last_change = state.last_change
      assert_receive {:watch, {:top_stories, ^last_change}}
    end

    test "should not send a message with the last published change when no change was published yet" do
      state = State.new()

      State.watch(state, self())
      Process.sleep(100)

      assert Process.info(self(), :messages) == {:messages, []}
    end
  end

  describe "unwatch/2" do
    test "should return a new state with the given process removed from watchers" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      {watch_ref, state} = State.watch(state, process)

      state = State.unwatch(state, watch_ref)

      assert state.watchers == []
    end

    test "should remove monitor reference of the given process" do
      state = State.new()
      process = spawn(fn -> Process.sleep(100) end)
      {watch_ref, state} = State.watch(state, process)

      State.unwatch(state, watch_ref)

      assert Process.info(process, :monitored_by) == {:monitored_by, []}
    end
  end

  describe "publish/2" do
    test "should send a message for all current watchers" do
      state = State.new()
      process = self()
      {_, state} = State.watch(state, process)

      State.publish_change(state, "test message")

      assert_received {:watch, {:top_stories, "test message"}}
    end

    test "should return a new state with the given change as the last change" do
      state = State.new()
      process = self()
      {_, state} = State.watch(state, process)

      state = State.publish_change(state, "test message")

      assert state.last_change == "test message"
    end
  end

  describe "watchers/1" do
    test "should return a list with all processes registered as watchers" do
      state = State.new()
      process = self()
      {_, state} = State.watch(state, process)

      assert State.watchers(state) == [process]
    end
  end
end
