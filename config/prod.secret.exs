use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :organizer, Organizer.Endpoint,
  secret_key_base: "iwTOgbYqLPEn6ssgH47HJVVCBB7oIO66lsKhcaLqpb7rn2qOujfHn2T0DYkb3hNF"

# Configure your database
config :organizer, Organizer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "pgsql",
  database: "organizer",
  pool_size: 20
