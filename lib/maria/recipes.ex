defmodule Maria.Recipes do
  @moduledoc """
  The Recipes context.
  """
  import Ecto.Query, warn: false
  alias Maria.Repo

  alias Maria.Recipes.Recipe

  @doc """
  Returns the list of recipes. If draft is true, only recipes not in draft will be returned

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes(draft \\ false) do

    query = if draft do
      from r in Recipe,
        where: is_nil(r.is_draft) or r.is_draft == false,
        order_by: [desc: coalesce(r.updated_at, r.inserted_at)]
    else
        from r in Recipe,
        order_by: [desc: coalesce(r.updated_at, r.inserted_at)]
    end


    query
    |> Repo.all()
    |> Repo.preload(:user)
    |> Repo.preload(:editor)
  end

  @doc """
  Returns the list of recipes by its author.

  ## Examples

      iex> list_recipes( %User{id: 1})
      [%Recipe{}, ...]

  """
  def list_recipes_by(user) do
    Recipe |> where(user_id: ^user.id) |> order_by([r], desc: coalesce(r.updated_at, r.inserted_at)) |> Repo.all() |> Repo.preload(:user) |> Repo.preload(:editor)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id) |> Repo.preload(:user) |> Repo.preload(:editor)

  @doc """
  Searches for recipes, max # results is 10.

  ## Examples

      iex> search("kimchi")
      [%Recipe{}, ...]
  """
  def search(search_query) do
    search_query = "%#{search_query}%"

    Recipe
    |> order_by(desc: :updated_at)
    |> or_where([p], ilike(p.directions, ^search_query))
    |> or_where([p], ilike(p.tags, ^search_query))
    |> or_where([p], ilike(p.title, ^search_query))
    |> or_where([p], ilike(p.description, ^search_query))
    |> limit(10)
    |> Repo.all()
    |> Repo.preload(:user)
  end


  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(socket, attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Recipe.upload_cover(socket)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, socket, attrs) do
    recipe
    |> Recipe.changeset_update(attrs)
    |> Recipe.upload_cover(socket)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    recipe
    |> Recipe.delete_cover()
    |> Repo.delete()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes
  during validation.

  ## Examples

      iex> validate_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def validate_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset_validate(recipe, attrs)
  end
end
