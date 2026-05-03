defmodule LanCall.MixProject do
  use Mix.Project

  def project do
    [
      app: :lan_call,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: [],
      escript: [main_module: LanCall.CLI]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {LanCall.Application, []}
    ]
  end
end
