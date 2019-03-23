defmodule GithubAppWeb.RepositoryController do
  @moduledoc """
  Repository controller API
  """
  use GithubAppWeb, :controller

  alias GithubApp.Repositories

  action_fallback(GithubAppWeb.FallBackController)

  def index(conn, %{"username" => username}) do
    repositories = Repositories.list_starred(username)
    render(conn, "repositories.json", %{repositories: repositories})
  end

  def search(conn, %{"tag" => tag}) do
    repositories = Repositories.list_repositories_by_tag(tag)
    render(conn, "repositories.json", %{repositories: repositories})
  end
end
