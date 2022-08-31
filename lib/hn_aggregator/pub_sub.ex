defmodule HNAggregator.PubSub do
  @moduledoc """
  A simple PubSub module to faciliate the communication between multiple
  components.
  """

  @server HNAggregator.PubSub.Server

  @spec subscribe() :: :ok
  def subscribe do
    GenServer.call(@server, :subscribe)
  end

  @spec publish(term()) :: :ok
  def publish(data) do
    GenServer.call(@server, {:publish, data})
  end

  @spec listeners() :: list(Process.dest())
  def listeners do
    GenServer.call(@server, :listeners)
  end
end
