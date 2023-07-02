defmodule :"Elixir.Maria.Repo.Migrations.Add-is-good-next-day" do
  use Ecto.Migration

  def change do
    alter table(:wines) do
      add :is_good_next_day, :boolean, default: false, null: false
    end
  end
end
