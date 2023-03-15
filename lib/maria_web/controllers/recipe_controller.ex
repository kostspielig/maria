defmodule MariaWeb.RecipeController do
  use MariaWeb, :controller

  require String
  alias Maria.Recipes
  alias Maria.Recipes.Recipe

  def index(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, :index, recipes: recipes)
  end

  def cook(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, :cook, recipes: recipes)
  end

  def new(conn, _params) do
    changeset = Recipes.change_recipe(%Recipe{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"recipe" => %{"cover" => cover_params } = recipe_params}) do
    {_, image_binary} = File.read(cover_params.path)
    link = MariaWeb.File.upload(cover_params.filename, recipe_params["title"], image_binary)

    updated_params =
      recipe_params
      |> Map.update("cover", "", fn _value -> link end)
      |> format_list_params()
      |> Map.put("user_id", conn.assigns.current_user.id)

    case Recipes.create_recipe(updated_params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe created successfully.")
        |> redirect(to: ~p"/recipes/#{recipe}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)

    render(conn, :show, recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    p = %{recipe | ingredients: Enum.join(recipe.ingredients, ","),
         tags: Enum.join(recipe.tags, ",")}

    changeset = Recipes.change_recipe(p)
    render(conn, :edit, recipe: p, changeset: changeset)
  end

  def update(conn, %{"id" => id, "recipe" => recipe_params}) do
    recipe = Recipes.get_recipe!(id)

    params =
      recipe_params
      |> format_list_params()
      |> Map.put("editor_id", conn.assigns.current_user.id)

    case Recipes.update_recipe(recipe, params) do
      {:ok, recipe} ->
        conn
        |> put_flash(:info, "Recipe updated successfully.")
        |> redirect(to: ~p"/recipes/#{recipe}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, recipe: recipe, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _recipe} = Recipes.delete_recipe(recipe)

    MariaWeb.File.delete(recipe.cover)

    conn
    |> put_flash(:info, "Recipe deleted successfully.")
    |> redirect(to: ~p"/recipes")
  end

  defp format_list_params(recipe_params) do
    %{recipe_params | "ingredients" => Map.get(recipe_params, "ingredients", "") |> String.split(",", trim: true),
      "tags" => Map.get(recipe_params, "tags", "") |> String.split(",", trim: true)}
  end
end
