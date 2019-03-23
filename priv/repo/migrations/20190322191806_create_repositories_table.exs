defmodule GithubApp.Repo.Migrations.CreateRepositoriesTable do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add(:git_repo_id, :integer)
      add(:name, :string)
      add(:clone_url, :string)
      add(:description, :text)
      add(:language, :string)

      timestamps()
    end

    create(unique_index(:repositories, :git_repo_id))
  end
end
