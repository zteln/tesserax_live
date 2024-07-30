defmodule TesseraxLive.MixProject do
  use Mix.Project

  def project do
    [
      app: :tesserax_live,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      name: "TesseraxLive",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 0.20.17"},
      {:phoenix_html, "~> 4.1"},
      {:tesserax, "~> 0.1"},
      {:ex_doc, "~> 0.34.2"}
    ]
  end

  defp description do
    "Provides a LiveComponent that renders a HTML5 canvas component for use with Tesserax."
  end

  defp package do
    [
      name: "TesseraxLive",
      licenses: ["MIT"],
      files: ~w(lib priv LICENSE mix.exs package.json README.md)
    ]
  end
end
