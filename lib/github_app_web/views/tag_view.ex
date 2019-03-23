defmodule GithubAppWeb.TagView do
  use GithubAppWeb, :view

  def render("tags.json", %{tags: tags}) do
    render_many(tags, GithubAppWeb.TagView, "tag.json", as: :tag)
  end

  def render("tag.json", %{tag: tag}) do
    %{tag: %{
      id: tag.id,
      repository_id: tag.repository_id,
      name: tag.name,  
    }}
  end
end
