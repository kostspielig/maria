defmodule MariaWeb.RecipeController do
  use MariaWeb, :controller

  require Logger
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

  def create(conn, %{"recipe" => recipe_params}) do
    params =
      recipe_params
      |> format_list_params()
      |> Map.put("user_id", conn.assigns.current_user.id)

    case Recipes.create_recipe(params) do
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
    recipe = %{recipe | mins: mins_to_duration(recipe.mins)}

    render(conn, :show, recipe: recipe)
  end

  def edit(conn, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    params = %{recipe | ingredients: Enum.join(recipe.ingredients, ","),
               tags: Enum.join(recipe.tags, ","),
               mins: mins_to_duration(recipe.mins)}

    changeset = Recipes.change_recipe(params)
    render(conn, :edit, recipe: params, changeset: changeset)
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

    {type, info} =
      case conn.assigns.current_user.id == recipe.user_id do
        :true ->
          {:ok, _recipe} = Recipes.delete_recipe(recipe)
          MariaWeb.File.delete(recipe.cover)
          {:info, "Recipe deleted successfully."}
        _ ->
          {:error, "You can only delete your own recipes"}
      end

    conn
    |> put_flash(type, info)
    |> redirect(to: ~p"/recipes")
  end

  defp format_list_params(recipe_params) do
    %{recipe_params | "ingredients" => Map.get(recipe_params, "ingredients", "") |> String.split(",", trim: true),
      "tags" => Map.get(recipe_params, "tags", "") |> String.split(",", trim: true),
      "mins" => Map.get(recipe_params, "mins", "0m") |> duration_in_minutes()}
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
        "#{value}#{suffix}"
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
