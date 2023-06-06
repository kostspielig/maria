defmodule Maria.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Maria.Accounts.User

  schema "recipes" do
    field :cover, :string
    field :description, :string
    field :directions, :string
    field :ingredients, :string
    field :mins, :string
    field :link, :string
    field :yield, :integer
    field :tags,  :string
    field :title, :string
    field :is_draft, :boolean

    belongs_to :user, User
    belongs_to :editor, User, foreign_key: :editor_id
    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :yield, :link, :tags, :is_draft, :user_id])
    |> validate_required([:title])
    |> validate_required_not_draft([:description, :directions, :mins, :ingredients, :tags])
    |> validate_cover(:required, true)
    |> unique_constraint(:title)
    |> foreign_key_constraint(:user_id)
  end

  @doc false
  def changeset_update(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :yield, :link, :tags, :is_draft, :editor_id])
    |> validate_required([:title])
    |> validate_required_not_draft([:description, :directions, :mins, :ingredients, :tags])
    |> validate_cover(:not_required)
    |> foreign_key_constraint(:editor_id)
  end

  @doc false
  def changeset_validate(recipe, attrs) do
    recipe
    |> cast(attrs, [:title, :description, :directions, :mins, :ingredients, :yield, :tags, :is_draft])
    |> validate_required([:title])
    |> validate_required_not_draft([:description, :directions, :mins, :ingredients, :tags])
    |> foreign_key_constraint(:user_id)
  end

  defp validate_required_not_draft(changeset, attrs) do
    if get_field(changeset, :is_draft) do
      changeset
    else
      changeset
      |> validate_required(attrs)
    end
  end

  @rx  ~r/(?i)\.(jpg|jpeg|png|gif)$/
  def validate_cover(changeset, required \\ :required, is_draft \\ false) do
    required = if is_draft and get_field(changeset, :is_draft) do
      :not_required
    else
      required
    end

    case Map.get(changeset.params, "cover", nil) do
      %Phoenix.LiveView.UploadEntry {client_name: filename} ->
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

  def delete_cover(recipe) do
    if recipe.cover do
      MariaWeb.File.delete(recipe.cover)
    end

    recipe
  end

  def upload_cover(%{valid?: true} = changeset, socket) do
    if cover = get_change(changeset, :cover) do
      file = MariaWeb.File.upload(changeset.params["cover"], cover, socket)

      if old_cover = changeset.data.cover do
        MariaWeb.File.delete(old_cover)
      end
      changeset
      |> put_change(:cover, file)
    else
      changeset
    end
  end

  def upload_cover(changeset, _) do changeset end

  def deformat_params(params) do
    Map.new(params, fn {k, v} ->
      case k do
        "ingredients" -> {k, if v !== "" do Enum.join(v, ",") else v end}
        "tags" ->{k, if v !== "" do Enum.join(v, ",") else v end}
        "mins" ->{k, if v !== "" do mins_to_duration(v) else v end}
        _ -> {k, v}
      end
    end)
  end


  def mins_to_duration(minutes) do
    {days, leftover_minutes} = {div(minutes, 60 * 24), rem(minutes, 60 * 24)}
    {hours, final_minutes} = {div(leftover_minutes, 60), rem(leftover_minutes, 60)}

    parts =
      [
        {days, "d"},
        {hours, "h"},
        {final_minutes, "m"}
      ]

    formatted_parts =
      for {value, suffix} <- parts, value > 0 do
        "#{value} #{suffix}"
      end

    Enum.join(formatted_parts, " ")
  end

  @rx ~r/^(?=.*\d)(\d+ ?d(ays?)?)? ?(\d+ ?h(ours?)?)? ?(\d+ ?m(inutes?)?)?$/i
  def duration_in_minutes(str) do
    if String.match?(str,@rx) do
      parts = str |> String.split(" ") |> Enum.map(&parse_part/1)
      Enum.reduce(parts, 0, fn x, acc -> x + acc end)
    else
      str
    end
  end

  defp parse_part(str) do
    IO.puts(str)
    [value, suffix] = Regex.split(~r/(?<=\d)(?=\D)/, str)

    case suffix do
      n when n in ["d", "day", "days"] -> String.to_integer(value) * 24 * 60
      n when n in ["h", "hour", "hours"] -> String.to_integer(value) * 60
      n when n in ["m", "minute", "minutes"] -> String.to_integer(value)
      _ -> 0
    end
  end
end
