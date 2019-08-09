use Mix.Config

# Configure your database
config :norm_boiler, NormBoiler.Repo,
  username: "postgres",
  password: "postgres",
  database: "norm_boiler_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :norm_boiler, NormBoilerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
