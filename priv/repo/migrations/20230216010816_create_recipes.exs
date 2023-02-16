defmodule Maria.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :title, :string
      add :description, :text
      add :directions, :text
      add :mins, :integer, default: 0, null: false
      add :ingredients, {:array, :string}
      add :likes, :integer, default: 0
      add :cover, :string
      add :link, :string
      add :tags, {:array, :string}

      timestamps()
    end
  end
end
