defmodule Maria.Repo.Migrations.CreateWines do
  use Ecto.Migration

  def change do
    create table(:wines) do
      add :name, :string
      add :description, :string
      add :vintage, :integer
      add :color, :string
      add :sweetness, :string
      add :body, :string
      add :region, :string
      add :grapes, :string
      add :alcohol, :float
      add :rating, :integer
      add :price, :float
      add :producer, :string
      add :country, :string
      add :image, :string
      add :is_featured, :boolean, default: false, null: false
      add :buy_link, :string
      add :is_draft, :boolean, default: false, null: false
      add :food_pairig, :string

      add :user_id, references(:users, on_delete: :nothing)
      add :editor_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
