defmodule Maria.Repo.Migrations.RecipeDrafts do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :is_draft, :boolean, default: false, null: false
    end
  end

end
