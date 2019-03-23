defmodule GithubAppWeb.TagControllerTest do
  use GithubAppWeb.ConnCase, async: true

  alias GithubApp.Repositories

  @moduletag :tags_api

  setup do
    {:ok, repo} =
      Repositories.create_repo(%{
        "git_repo_id" => 123,
        "name" => "repo",
        "clone_url" => "https://example.com"
      })

    {:ok, tag} =
      Repositories.create_tag(%{"repository_id" => repo.id, "name" => "repo"})

    [repo: repo, tag: tag]
  end

  describe "POST /api/repositories/:id/tags" do
    test "creates tags", %{conn: conn, repo: repo} do
      attrs = %{
        "tags" => [
          "frontend",
          "frontend",
          "backend",
          "backend",
          "elixir"
        ]
      }

      conn = post(conn, Routes.api_tag_path(conn, :create, repo), attrs)
      response = json_response(conn, 200)

      assert Enum.count(response) == 4
    end
  end

  describe "PUT /api/tags/:id" do
    test "updates a tag", %{conn: conn, tag: tag} do
      attrs = %{"tag" => %{"name" => "my tag"}}

      conn = put(conn, Routes.api_tag_path(conn, :update, tag), attrs)
      response = json_response(conn, 200)

      assert response["tag"]["name"] == "my tag"
    end
  end

  describe "DELETE /api/tags/:id" do
    test "deletes a tag", %{conn: conn, tag: tag} do
      conn = delete(conn, Routes.api_tag_path(conn, :delete, tag))
      response = json_response(conn, 200)

      assert response["tag"]["id"] == tag.id
    end
  end
end
