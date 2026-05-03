defmodule Vcex.MixProject do
  use Mix.Project

  def project do
    [
      app: :vcex,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: [],
      escript: [main_module: Vcex.CLI]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {Vcex.Application, []}
    ]
  end
end
