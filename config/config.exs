# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :organizer, Organizer.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "GruXsIQ1YeiqBcy5fnfjSOhjq1Ce8CU/jAkAEeeSgLG25scU9EDtjESMcBSP88FI",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Organizer.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :organizer, Organizer.Gettext, default_locale: "es"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: true

config :organizer, Facebook,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET"),
  redirect_uri: System.get_env("FACEBOOK_REDIRECT_URI")

config :organizer, Google,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_REDIRECT_URI")

config :organizer, GitHub,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_REDIRECT_URI")

config :organizer, Organizer.AuthController, single_user: false, #or false for Facebook App
user: %{ name: "Christian Melgarejo", email: "cmelgarejo@centralgps.net", doc: "123456",
password: "password", dob: "1979-01-01", gender: "male", image_url: nil, birthday: nil,
timezone: "-4", locale: "es", demo: false, active: true, xtra_info: nil}
