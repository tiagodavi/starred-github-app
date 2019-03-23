defmodule GithubApp.Repo do
  use Ecto.Repo,
    otp_app: :github_app,
    adapter: Ecto.Adapters.Postgres
end
