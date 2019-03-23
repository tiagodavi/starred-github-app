defmodule GithubAppWeb.RepositoryView do
  use GithubAppWeb, :view

  def render("repositories.json", %{repositories: repositories}) do
    render_many(repositories, GithubAppWeb.RepositoryView, "repository.json", as: :repository)
  end

  def render("repository.json", %{repository: repository}) do
    %{
      repository: %{
        id: repository.id,
        git_repo_id: repository.git_repo_id,
        name: repository.name,
        description: repository.description,
        url: repository.clone_url,
        language: repository.language,
        tags: render_many(repository.tags, GithubAppWeb.TagView, "tag.json", as: :tag),
        tag_recommendations: repository.tag_recommendations
      }
    }
  end
end
