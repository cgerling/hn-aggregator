defmodule HNAggregator.MixProject do
  use Mix.Project

  def project do
    [
      app: :hn_aggregator,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {HNAggregator, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_env), do: ["lib"]

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev], runtime: false},
      {:hackney, "~> 1.18"},
      {:hammox, "~> 0.7", only: [:test]},
      {:jason, "~> 1.3"},
      {:tesla, "~> 1.4"}
    ]
  end
end
