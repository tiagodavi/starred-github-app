defmodule GithubAppWeb.RepositoryControllerTest do
  use GithubAppWeb.ConnCase, async: true

  alias GithubApp.Repositories

  @moduletag :repositories_api

  describe "GET /api/repositories/:username/starred" do
    test "returns list of starred repositories", %{conn: conn} do
      conn = get(conn, Routes.api_repository_path(conn, :index, "tiagodavi"))
      response = json_response(conn, 200)

      assert Enum.count(response) == 3
    end

    test "returns empty list when there are no repositories", %{conn: conn} do
      conn = get(conn, Routes.api_repository_path(conn, :index, "anyone"))
      response = json_response(conn, 200)

      assert Enum.count(response) == 0
    end
  end

  describe "GET /api/repositories/search/:tag" do
    test "returns list of repositories according to tag", %{conn: conn} do
      {:ok, repo_a} =
        Repositories.create_repo(%{
          "git_repo_id" => 123,
          "name" => "repo_a",
          "clone_url" => "https://example.com"
        })

      {:ok, repo_b} =
        Repositories.create_repo(%{
          "git_repo_id" => 321,
          "name" => "repo_b",
          "clone_url" => "https://example.com"
        })

      {:ok, _tag} =
        Repositories.create_tag(%{"repository_id" => repo_a.id, "name" => "backend"})

      {:ok, _tag} =
        Repositories.create_tag(%{"repository_id" => repo_a.id, "name" => "javascript"})

      {:ok, _tag} =
        Repositories.create_tag(%{"repository_id" => repo_b.id, "name" => "java"})

      conn = get(conn, Routes.api_repository_path(conn, :search, "back"))
      response_a = json_response(conn, 200)

      conn = get(conn, Routes.api_repository_path(conn, :search, "java"))
      response_b = json_response(conn, 200)

      assert Enum.count(response_a) == 1
      assert Enum.count(response_b) == 2
    end
  end
end
