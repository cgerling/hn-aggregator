defmodule HNAggregator.Pool do
  @spec fetch_worker(Supervisor.supervisor()) :: pid()
  def fetch_worker(pool) do
    {_id, pid, _type, _modules} =
      pool
      |> Supervisor.which_children()
      |> Enum.random()

    pid
  end
end
