# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chit_chat_en,
  ecto_repos: [ChitChatEn.Repo]

# Configures the endpoint
config :chit_chat_en, ChitChatEnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Un8X+FGAEz4OxwLTq1eth3z7M3bCmNtjNo+UOxGNARAfEk5WBNNY7Vgz6O4S6GM5",
  render_errors: [view: ChitChatEnWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChitChatEn.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :guardian, Guardian,
  issuer: "ChitChatEn.#{Mix.env()}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: ChitChatEn.GuardianSerializer,
  secret_key: to_string(Mix.env()) <> "SuPerseCret_aBraCadaBrA"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
