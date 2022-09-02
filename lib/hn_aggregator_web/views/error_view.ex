defmodule HNAggregatorWeb.ErrorView do
  use HNAggregatorWeb, :view

  @spec render(String.t(), map()) :: map()
  def render("404.json", assigns) do
    message = Map.get(assigns, :message, "Not Found")
    %{message: message}
  end

  def render("500.json", _assigns) do
    %{message: "Internal Server Error"}
  end

  @spec template_not_found(String.t(), map()) :: map()
  def template_not_found(_template, _assigns) do
    render("500.json", %{})
  end
end
