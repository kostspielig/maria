defmodule Maria.Repo.Migrations.RecipesAddAuthor do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :editor_id, references(:users, on_delete: :nothing)
    end
  end
end
