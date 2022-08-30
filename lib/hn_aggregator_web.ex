defmodule HNAggregatorWeb do
  @moduledoc false

  @spec controller() :: Macro.t()
  def controller do
    quote do
      use Phoenix.Controller, namespace: HNAggregatorWeb

      import Plug.Conn

      alias HNAggregatorWeb.Router.Helpers, as: Routes
    end
  end

  @spec router() :: Macro.t()
  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  @spec view() :: Macro.t()
  def view do
    quote do
      import Phoenix.View

      alias HNAggregatorWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
