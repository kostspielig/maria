defmodule Maria.Drinking.Wine do
  use Ecto.Schema
  import Ecto.Changeset

  alias Maria.Accounts.User

  schema "wines" do
    field :alcohol, :float
    field :body, :string
    field :buy_link, :string
    field :color, :string
    field :country, :string
    field :description, :string
    field :food_pairig, :string
    field :grapes, :string
    field :image, :string
    field :is_draft, :boolean, default: false
    field :is_featured, :boolean, default: false
    field :is_good_next_day, :boolean, default: false
    field :title, :string
    field :price, :float
    field :producer, :string
    field :rating, :integer
    field :region, :string
    field :sweetness, :string
    field :vintage, :integer

    belongs_to :user, User
    belongs_to :editor, User, foreign_key: :editor_id

    timestamps()
  end

  @doc false
  def changeset(wine, attrs) do
    wine
    |> cast(attrs, [:title, :description, :vintage, :color, :sweetness, :body, :region, :grapes, :alcohol, :rating, :price, :producer, :country, :image, :is_featured, :is_good_next_day, :buy_link, :is_draft, :food_pairig, :user_id])
    |> validate_required([:title, :description, :vintage, :color])
    |> foreign_key_constraint(:user_id)
  end

  @doc false
  def changeset_update(wine, attrs) do
    wine
    |> cast(attrs, [:title, :description, :vintage, :color, :sweetness, :body, :region, :grapes, :alcohol, :rating, :price, :producer, :country, :image, :is_featured, :is_good_next_day, :buy_link, :is_draft, :food_pairig, :editor_id])
    |> validate_required([:title, :description, :vintage, :color])
    |> foreign_key_constraint(:editor_id)
  end
end
