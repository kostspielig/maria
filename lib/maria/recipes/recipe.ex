defmodule Maria.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Maria.Accounts.User

  schema "recipes" do
    field :cover, :string
    field :description, :string
    field :directions, :string
    field :ingredients, {:array, :string}
    field :likes, :integer
    field :link, :string
    field :mins, :integer
    field :tags, {:array, :string}
    field :title, :string

    belongs_to :user, User
    belongs_to :editor, User, foreign_key: :editor_id
    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :likes, :tags, :cover, :user_id])
    |> validate_required([:title, :description, :directions, :mins, :ingredients, :tags, :cover])
    |> validate_format(:cover, ~r/(?i)\.(jpg|jpeg|png|gif)$/)
    |> foreign_key_constraint(:user_id)
  end

  @doc false
  def changeset_update(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :likes, :tags, :cover, :editor_id])
    |> validate_required([:title, :description, :directions, :mins, :ingredients, :tags, :cover])
    |> foreign_key_constraint(:editor_id)
  end
end
