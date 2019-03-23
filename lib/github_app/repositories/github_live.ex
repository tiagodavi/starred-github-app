defmodule GithubApp.Repositories.GithubLive do
  @moduledoc """
  Use this module to connect to the real github api.
  """
  use Tesla

  @behaviour GithubApp.Repositories.GithubBehaviour

  alias GithubApp.Repositories

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"

  plug Tesla.Middleware.Headers, [
    {"Accept", "application/vnd.github.v3.star+json"}
  ]

  plug Tesla.Middleware.JSON

  @doc """
  Returns list of starred repositories.

  ## Examples

      iex> list_starred(username)
      [%Repository{}, ...]

  """
  @impl GithubApp.Repositories.GithubBehaviour
  def list_starred(username) do
    repositories = load_from_github(username)
    Repositories.build_repositories(repositories)
    Repositories.list_repositories()
  end

  defp load_from_github(username, page \\ 1, per_page \\ 30, acc \\ []) do
    case get("/users/" <> username <> "/starred?page=#{page}&per_page=#{per_page}") do
      {:ok, %Tesla.Env{body: body, status: 200, headers: headers}} ->
        link = Enum.find(headers, &find_link/1)

        acc =
          body
          |> Stream.map(&build_repo_struct/1)
          |> Enum.concat(acc)

        if link do
          load_from_github(username, page + 1, per_page, acc)
        else
          acc
        end

      _ ->
        []
    end
  end

  defp build_repo_struct(%{"repo" => repo}) do
    today =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    %{
      git_repo_id: repo["id"],
      name: repo["name"],
      clone_url: repo["clone_url"],
      description: repo["description"],
      language: repo["language"],
      inserted_at: today,
      updated_at: today
    }
  end

  defp find_link({"link", link}) do
    Regex.match?(~r/next/, link)
  end

  defp find_link(_), do: false
end
