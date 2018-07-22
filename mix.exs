defmodule OnePlusNDetector.MixProject do
  use Mix.Project

  def project do
    [
      app: :one_plus_n_detector,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, env: :dev, override: true}
    ]
  end

  defp package do
    [
      files: ["lib", "src", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/san650/one_plus_n_detector"},
      maintainers: ["Santiago Ferreira"],
      name: :one_plus_n_detector,
    ]
  end

  defp description do
    """
    Detect 1+n queries in your Ecto application.
    """
  end
end
