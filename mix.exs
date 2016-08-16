defmodule ConsulInformant.Mixfile do
  use Mix.Project

  def project do
    [app: :consul_informant,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      mod: {ConsulInformant, []},
      applications: [:logger, :gen_stage]
    ]
  end

  defp deps do
    [
      {:exjsx, "~> 3.2"},
      {:gen_stage, "~> 0.4"},
      {:httpoison, "~> 0.9.0"},
      {:credo, "~> 0.4", only: [:dev, :test]}
    ]
  end
end
