# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :bank_api,
  ecto_repos: [BankApi.Repo]

# Configures the endpoint
config :bank_api, BankApi.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JKPbo/xUU2V7vEUiEL4OSzbYBWnbaJfaUEgOP3j54sSbp+fR5CGObzmYuglfleOi",
  render_errors: [view: BankApi.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
