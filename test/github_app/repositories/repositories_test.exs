defmodule GithubApp.RepositoriesTest do
  use GithubApp.DataCase, async: true

  alias GithubApp.Repositories

  @moduletag :repositories

  describe "list_starred/1" do
    test "returns all starred repositories according to username" do
      response = Repositories.list_starred("tiagodavi")

      assert Enum.count(response) == 3
    end

    test "returns empty list when there are no starred repositories" do
      response = Repositories.list_starred("anyone")

      assert Enum.count(response) == 0
    end
  end

  describe "create_tags/2" do
    test "creates tags ignoring duplicate ones" do
      tags = [
        "frontend",
        "frontend",
        "backend",
        "elixir"
      ]

      assert {:ok, repo} =
               Repositories.create_repo(%{
                 "git_repo_id" => 123,
                 "name" => "repo",
                 "clone_url" => "https://example.com"
               })

      assert {:ok, tags} = Repositories.create_tags(repo.id, tags)
    end
  end
end
