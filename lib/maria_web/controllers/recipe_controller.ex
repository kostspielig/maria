defmodule MariaWeb.RecipeController do
  use MariaWeb, :controller

  require String
  alias Maria.Recipes

  def cook(conn, _params) do
    recipes = Recipes.list_recipes()
    render(conn, :cook, recipes: recipes)
  end

end
