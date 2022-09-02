defmodule HNAggregatorWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import HNAggregatorWeb.ConnCase

      alias HNAggregatorWeb.Router.Helpers, as: Routes

      @endpoint HNAggregatorWeb.Endpoint
    end
  end

  setup do
    conn = Phoenix.ConnTest.build_conn()

    {:ok, conn: conn}
  end
end
