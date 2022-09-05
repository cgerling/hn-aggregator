defmodule HNAggregator.Pool.Supervisor do
  use Supervisor

  @default_size 5

  @spec start_link(Keyword.t()) :: Supervisor.on_start()
  def start_link(options) do
    name = Keyword.get(options, :name, __MODULE__)

    Supervisor.start_link(__MODULE__, options, name: name)
  end

  @impl Supervisor
  def init(options) do
    worker = Keyword.fetch!(options, :worker)
    size = Keyword.get(options, :size, @default_size)

    children = Enum.map(1..size, &Supervisor.child_spec(worker, id: {worker, &1}))

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
