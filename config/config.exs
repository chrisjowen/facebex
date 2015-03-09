# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"

config :facebook_sdk, :security,
    appId: "832164533516129",
    appSecret: "12205a971859c0ef78ce31931e4ff61a",
    userAccessToken: "CAAL02WdqN2EBALdeqSGa7YbhBhxrxIN419lX65dAYAsMjzimTes4jfBcP2kzXRXnJlll7Q4YkVTvfYqlaHuJvqGyOTN2D84ZBeltHAgdIMmzxWX1q8KCWs2aOdjKphArUzY8Ytf6TrfkPnwWZC2okbqEpDiEL7nATpGSzeFDyUEVxycBIA2DOWnZCjbVf8ZBb3dc2VY72R5HdU3fDdEC"