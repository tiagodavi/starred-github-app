use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :github_app, GithubAppWeb.Endpoint,
  http: [port: 4001],
  server: false

config :github_app, GithubApp.Repo, pool: Ecto.Adapters.SQL.Sandbox
config :github_app, github_api: GithubApp.Repositories.GithubMock

# Print only warnings and errors during test
config :logger, level: :warn
