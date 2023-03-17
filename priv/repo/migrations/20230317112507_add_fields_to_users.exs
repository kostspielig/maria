defmodule Maria.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string, null: false, default: "lecookie"
    end
  end
end
