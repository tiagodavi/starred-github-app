defmodule GithubApp.Repo.Migrations.CreateTagsTable do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add(:name, :string)
      add(:repository_id, references(:repositories, on_delete: :delete_all))

      timestamps()
    end

    create(index(:tags, :name))
    create(unique_index(:tags, [:name, :repository_id]))
  end
end
