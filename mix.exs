defmodule ZiosPizza.MixProject do
  use Mix.Project

  def project do
    [
      app: :zios_pizza,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [
        plt_file: {:no_warn, "_build/plts/dialyzer.plt"},
        plt_add_apps: [:mix, :eex, :ex_unit],
        flags: [:underspecs, :unknown, :unmatched_returns, :error_handling],
        ignore_warnings: ".dialyzer_ignore.exs"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ZiosPizza.Application, []}
    ]
  end

  defp aliases do
    [
      credo: ["credo --config-name zios_pizza --strict"],
      seed: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "run priv/repo/seeds.exs"
      ],
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "run test/seeds.exs",
        "test"
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(env) when env in [:dev, :test], do: ["lib", "test/support", "credo"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.14"},
      {:cowboy, "~> 2.9"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.6"},
      {:ecto_sql, "~> 3.9"},
      {:postgrex, "~> 0.16"},
      {:poolboy, "~> 1.5"},
      {:ex_json_schema, "~> 0.9"},
      # {:remix, "~> 0.0.2", only: :dev},
      {:remixed_remix, "~> 2.0", only: :dev},
      {:mock, "~> 0.3", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
