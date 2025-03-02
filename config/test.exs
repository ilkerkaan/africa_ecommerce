import Config

# Configure your database
config :dukkadee, Dukkadee.Repo,
  username: "postgres",
  password: "20911980", # Replace with the password you set during installation
  hostname: "localhost",
  database: "dukkadee_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  adapter: Ecto.Adapters.Postgres

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dukkadee, DukkadeeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QdvPrIcXBRRxwvQbZnqNDQWPZFxzHkTOlzOWVgcSXXQSRGTALOBMUHRXWZrQDEPE",
  server: false

# In test we don't send emails.
config :dukkadee, Dukkadee.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
