defmodule Maria.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Maria.Accounts.User

  schema "recipes" do
    field :cover, :string
    field :description, :string
    field :directions, :string
    field :ingredients, {:array, :string}
    field :mins, :integer
    field :link, :string
    field :yield, :integer
    field :tags, {:array, :string}
    field :title, :string

    belongs_to :user, User
    belongs_to :editor, User, foreign_key: :editor_id
    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :yield, :link, :tags, :user_id])
    |> validate_required([:title, :description, :directions, :mins, :ingredients, :tags])
    |> validate_cover(:required)
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
  end

  @doc false
  def changeset_update(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :yield, :link, :tags, :editor_id])
    |> validate_required([:title, :description, :directions, :mins, :ingredients, :tags])
    |> validate_cover(:not_required)
    |> foreign_key_constraint(:editor_id)
  end

  @rx  ~r/(?i)\.(jpg|jpeg|png|gif)$/
  def validate_cover(changeset, required \\ :required) do
    case changeset.params["cover"] do
      %Plug.Upload {filename: filename} ->
        if String.match?(filename, @rx) do
          changeset
          |> put_change(:cover, MariaWeb.File.generate_name(filename, changeset.params["title"]))
        else
          add_error(changeset, :cover, "Invalid cover image format (jpg, jpeg, png, gif)")
        end
      _ ->
        case required do
          :required -> add_error(changeset, :cover,  "Cover image is required")
          _ -> changeset
        end
    end
  end

  def upload_cover(%{valid?: true}= changeset ) do
    if cover = get_change(changeset, :cover) do
      file = MariaWeb.File.upload(changeset.params["cover"], cover)
      if old_cover = changeset.data.cover do
        MariaWeb.File.delete(old_cover)
      end
      changeset
      |> put_change(:cover, file)
    else
      changeset
    end
  end

  def upload_cover(changeset) do changeset end
end
