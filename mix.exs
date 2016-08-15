defmodule Organizer.Mixfile do
  use Mix.Project

  def project do
    [app: :organizer,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    apps = [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                   :phoenix_ecto, :postgrex, :poison, :oauth2]
    dev_apps = Mix.env == :dev && [ :reprise, :phoenix_live_reload ] || []
    [ mod: {Organizer, []}, applications: dev_apps ++ apps ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      #{:cowboy,              github: "ninenines/cowboy", override: true}
      {:cowboy,               "~> 1.0"},
      {:exrm,                 github: "bitwalker/exrm"},
      #{:conform,              github: "bitwalker/conform", only: :dev}, #only good to create the onfig schema and .conf file
      #{:httpoison,            github: "edgurgel/httpoison"},
      #{:logger_file_backend,  github: "onkel-dirtus/logger_file_backend"},
      {:phoenix,              github: "phoenixframework/phoenix", override: true},
      {:phoenix_live_reload,  github: "phoenixframework/phoenix_live_reload", only: :dev},
      {:phoenix_html,         github: "phoenixframework/phoenix_html", override: true},
      {:phoenix_ecto,         github: "phoenixframework/phoenix_ecto"},
      #{:postgrex,             github: "ericmj/postgrex", override: true}, #Still no fix for Postgrex.Connection (19/1/2016)
      {:postgrex,             ">= 0.0.0"}, #0.10.0 Still uses :connection fix on apps list
      {:reprise,              github: "herenowcoder/reprise", only: :dev},
      {:oauth2,               github: "scrogson/oauth2"},
      {:phoenix_live_reload,  github: "phoenixframework/phoenix_live_reload", only: :dev}, #"~> 1.0", only: :dev},
      {:gettext,              github: "elixir-lang/gettext"}
   ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end
