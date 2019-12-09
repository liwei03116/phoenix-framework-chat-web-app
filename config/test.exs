use Mix.Config

# Configure your database
config :chit_chat_en, ChitChatEn.Repo,
  username: "postgres",
  password: "postgres",
  database: "chit_chat_en_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chit_chat_en, ChitChatEnWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
