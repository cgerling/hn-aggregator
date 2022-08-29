defmodule HNAggregator.TopStories.Poller.StateTest do
  use ExUnit.Case, async: true

  alias HNAggregator.TopStories.Poller.State

  describe "new/1" do
    test "should return a state struct with default values" do
      state = State.new(target: TargetModule)

      assert %State{} = state
      assert state.target == TargetModule
      assert state.rate == 5 * 60 * 1000
    end

    test "should return a state struct with the given rate" do
      rate = :rand.uniform(10_000)
      state = State.new(target: TargetModule, rate: rate)

      assert %State{} = state
      assert state.target == TargetModule
      assert state.rate == rate
    end
  end
end
