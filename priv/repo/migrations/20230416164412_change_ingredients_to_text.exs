defmodule Maria.Repo.Migrations.ChangeIngredientsToText do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      modify :ingredients, :text, from: :string
    end
  end
end
