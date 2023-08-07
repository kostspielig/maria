defmodule Maria.Repo.Migrations.UpdateWineNameField do
  use Ecto.Migration

  def change do
    rename table("wines"), :name, to: :title
  end
end
