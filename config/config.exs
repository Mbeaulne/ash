# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :norm_boiler,
  ecto_repos: [NormBoiler.Repo]

# Configures the endpoint
config :norm_boiler, NormBoilerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eeDdG4QbpBNVCl0lckayx2Dc5kKOGVHVLrW9WW8NZPIsphmAOvkcaPEDcVf2JdK9",
  render_errors: [view: NormBoilerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: NormBoiler.PubSub, adapter: Phoenix.PubSub.PG2]

config :norm_boiler, NormBoiler.Guardian,
      issuer: "norm_boiler",
      secret_key: "voyD3scK9iUUBjn/6U0JV04r6TqnARwtKP+1DnGWgBWaGnJX4+Kf1IQcc44IvKts"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
