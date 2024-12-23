defmodule Stack.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :stack,
      version: @version,
      elixir: "~> 1.14",
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      compilers: Mix.compilers(),
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.detail": :test,
        "coveralls.json": :test,
        "coveralls.post": :test
      ],
      dialyzer: [plt_add_apps: [:mix]],
      source_url: "https://github.com/renatomassaro/stack",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: []
    ]
  end

  defp description do
    """
    Simple yet complete Stack data structure.
    """
  end

  defp package do
    [
      maintainers: ["Renato Massaro"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/renatomassaro/stack"
      }
    ]
  end

  def deps do
    [
      {:ex_doc, "~> 0.35", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:mix_test_watch, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    []
  end

  defp docs do
    [
      main: "Stack"
    ]
  end
end
