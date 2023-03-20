defmodule Maria.Repo.Migrations.SimplifyRecipe do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      modify :ingredients, :string, from: {:array, :string}
      modify :tags, :string, from: {:array, :string}
      modify :mins, :string, from: :integer
    end

  end
end
