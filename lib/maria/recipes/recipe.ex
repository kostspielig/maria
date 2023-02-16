defmodule Maria.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :cover, :string
    field :descrition, :string
    field :directions, :string
    field :ingredients, {:array, :string}
    field :likes, :integer
    field :link, :string
    field :mins, :integer
    field :tags, {:array, :string}
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :descrition, :directions, :mins, :ingredients, :likes, :tags])
    |> validate_required([:title, :descrition, :directions, :mins, :ingredients, :tags])
  end
end
