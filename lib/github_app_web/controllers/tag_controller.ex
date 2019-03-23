defmodule GithubAppWeb.TagController do
  @moduledoc """
  Tag controller API
  """
  use GithubAppWeb, :controller

  alias GithubAppWeb.CatchAllController
  alias GithubApp.Repositories

  action_fallback(GithubAppWeb.FallBackController)

  def create(conn, %{"id" => repository_id, "tags" => entries}) do
    with {:ok, repository} <- Repositories.get_repo(id: repository_id),
         {:ok, tags} <- Repositories.create_tags(repository.id, entries) do
      render(conn, "tags.json", %{tags: tags})
    end
  end
  def create(conn,_), do: CatchAllController.index(conn, nil)

  def update(conn, %{"id" => tag_id, "tag" => attrs}) do
    with {:ok, tag} <- Repositories.get_tag(id: tag_id),
         {:ok, tag} <- Repositories.update_tag(tag, attrs) do
      render(conn, "tag.json", %{tag: tag})
    end
  end
  def update(conn,_), do: CatchAllController.index(conn, nil)

  def delete(conn, %{"id" => tag_id}) do
    with {:ok, tag} <- Repositories.get_tag(id: tag_id),
         {:ok, tag} <- Repositories.delete_tag(tag) do
      render(conn, "tag.json", %{tag: tag})
    end
  end
  def delete(conn,_), do: CatchAllController.index(conn, nil)
end
