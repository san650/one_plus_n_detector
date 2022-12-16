defmodule OnePlusNDetector.MixProject do
  use Mix.Project

  def project do
    [
      app: :one_plus_n_detector,
      deps: deps(),
      description: description(),
      elixir: "~> 1.4",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.1.1",
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/san650/one_plus_n_detector"},
      maintainers: ["Santiago Ferreira"],
      name: :one_plus_n_detector,
    ]
  end

  defp description do
    """
    Detect 1+n SQL queries in your Ecto application.
    """
  end
end
