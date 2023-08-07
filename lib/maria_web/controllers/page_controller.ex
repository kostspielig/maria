defmodule MariaWeb.PageController do
  use MariaWeb, :controller

  alias Maria.Recipes

  def home(conn, _params) do
    recipes = Recipes.list_recipes(true, 5)
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, recipes: recipes)
  end
end
