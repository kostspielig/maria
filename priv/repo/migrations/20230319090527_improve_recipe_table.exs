defmodule Maria.Repo.Migrations.ImproveRecipeTable do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :yield, :integer
      remove :likes, :integer
    end
  end
end
