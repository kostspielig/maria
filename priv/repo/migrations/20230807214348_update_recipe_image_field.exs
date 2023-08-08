defmodule Maria.Repo.Migrations.UpdateRecipeImageField do
  use Ecto.Migration

  def change do
    rename table("recipes"), :cover, to: :image
  end
end
