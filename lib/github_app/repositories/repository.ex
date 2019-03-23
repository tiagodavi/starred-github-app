defmodule GithubApp.Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field(:git_repo_id, :integer)
    field(:name, :string)
    field(:clone_url, :string)
    field(:description, :string)
    field(:language, :string)
    field(:tag_recommendations, {:array, :string}, virtual: true, default: [])
    has_many(:tags, GithubApp.Repositories.Tag)

    timestamps()
  end

  @required_fields [
    :git_repo_id,
    :name,
    :clone_url
  ]

  @optional_fields [:description, :language]

  def changeset(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:git_repo_id, message: "This git_repo_id has already been taken")
  end
end
