defmodule GithubApp.Repositories.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field(:name, :string)
    belongs_to(:repository, GithubApp.Repositories.Repository)

    timestamps()
  end

  @required_fields [
    :name,
    :repository_id
  ]

  def changeset(schema, attrs \\ %{}) do
    schema
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:repository_id)
    |> unique_constraint(:name,
      name: :tags_name_repository_id_index,
      message: "This tag has already been taken for this repo"
    )
  end
end
