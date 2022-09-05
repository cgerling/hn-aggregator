defmodule HNAggregator.PoolTest do
  use ExUnit.Case, async: true

  alias HNAggregator.Pool

  describe "fetch_worker/1" do
    test "should return a pid of a worker from the given pool", context do
      start_supervised!({Pool.Supervisor, worker: {Agent, fn -> :ok end}, name: context.test})

      worker_pid = Pool.fetch_worker(context.test)
      assert is_pid(worker_pid)
    end
  end
end
