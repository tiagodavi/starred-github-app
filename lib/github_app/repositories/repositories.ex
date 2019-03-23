defmodule GithubApp.Repositories do
  @moduledoc """
  Repositories Context
  """
  alias GithubApp.Repositories.{Repository, RecommendationsCache, Tag}
  alias GithubApp.Repo

  import Ecto.Query, only: [from: 2]

  @github_api Application.get_env(:github_app, :github_api)

  @doc """
  Returns list of starred repositories.

  ## Examples

      iex> list_starred(username)
      [%Repository{}, ...]

  """
  def list_starred(username) do
    @github_api.list_starred(username)
  end

  @doc """
  Returns list of all repositories.

  ## Examples

      iex> list_repositories()
      [%Repository{}, ...]

  """
  def list_repositories do
    list_repositories_query()
    |> Repo.all()
    |> Enum.map(&RecommendationsCache.build_recommendations/1)
  end

  @doc """
  Returns repositories according to the tag.

  ## Examples

      iex> list_repositories_by_tag(tag)
      [%Repository{}, ...]

  """
  def list_repositories_by_tag(tag) do
    query = from([tags: t] in list_repositories_query(),
     where: ilike(t.name, ^"#{tag}%")
    )
    Repo.all(query)
    |> Enum.map(&RecommendationsCache.build_recommendations/1)
  end

  @doc """
  Returns up to 100 tags from database.

  ## Examples

      iex> list_tags
      ["frontend", ...]

  """
  def list_tags do
    query = from(t in Tag, limit: 100, select: t.name)
    Repo.all(query)
  end

  @doc """
  Returns tags according to the filters.

  ## Examples

      iex> list_tags_by(name: value, repository_id: value)
      [%Tag{}, ...]

  """
  def list_tags_by(filters) do
    query = from(t in Tag, where: ^filters, select: t)
    Repo.all(query)
  end

  @doc """
  Creates a Repository.

  ## Examples

      iex> create_repo(%{field: value})
      {:ok, %Repository{}}

      iex> create_repo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_repo(attrs \\ %{}) do
    %Repository{}
    |> Repository.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates multiple repositories at once.

  ## Examples

      iex> build_repositories(repositories)
      {number, string}

  """
  def build_repositories(repositories) do
    Repo.insert_all(Repository, repositories,
      on_conflict: :replace_all_except_primary_key,
      conflict_target: [:git_repo_id]
    )
  end

  @doc """
  Creates multiple tags at once.

  ## Examples

      iex> build_tags(tags)
      {number, string}

  """
  def build_tags(tags) do
    Repo.insert_all(Tag, tags, on_conflict: :nothing, conflict_target: [:name, :repository_id])
  end

  @doc """
  Creates a Tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates Tags.

  ## Examples

      iex> create_tags(repository_id, entries)
      {:ok, [%Tag{}]}

      iex> create_tags(repository_id, [])
      {:error, "Tags list has invalid format"}

      iex> create_tags(invalid, [])
      {:error, "repository_id is invalid"}

  """
  def create_tags(repository_id, [_ | _] = entries) do
    today =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    repository_id =
      case Integer.parse(to_string(repository_id)) do
        {value, ""} -> value
        _ -> nil
      end

    if repository_id do
      tags =
        Enum.map(
          entries,
          &%{name: &1, repository_id: repository_id, inserted_at: today, updated_at: today}
        )

      build_tags(tags)

      {:ok, list_tags_by(repository_id: repository_id)}
    else
      {:error, "repository_id is invalid"}
    end
  end

  def create_tags(_, _), do: {:error, "Tags list has invalid format"}

  @doc """
  Updates a Tag.

  ## Examples

      iex> update_tag(%{field: value})
      {:ok, %Tag{}}

      iex> update_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs \\ %{}) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end


  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Gets a single repository according to filters.

  ## Examples

      iex> get_repo(id: 123)
      {:ok, %Repository{}}

      iex> get_repo(git_repo_id: 321)
      {:error, "Repository has not been found"}

  """
  def get_repo(filters) do
    case Repo.get_by(Repository, filters) do
      %Repository{} = repository ->
        {:ok, repository}

      _ ->
        {:error, "Repository has not been found"}
    end
  end

  @doc """
  Gets a single tag according to filters.

  ## Examples

      iex> get_tag(id: 123)
      {:ok, %Tag{}}

      iex> get_tag(id: 456)
      {:error, "Tag has not been found"}

  """
  def get_tag(filters) do
    case Repo.get_by(Tag, filters) do
      %Tag{} = tag ->
        {:ok, tag}
      _ ->
        {:error, "Tag has not been found"}
    end
  end

  defp list_repositories_query do
    from(r in Repository,
     as: :repositories,
     left_join: t in assoc(r, :tags),
     as: :tags,
     select: r,
     preload: [tags: t]
    )
  end
end
