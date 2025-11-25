defmodule MariaWeb.PageController do
  use MariaWeb, :controller

  alias Maria.Recipes
  alias Maria.Drinking

  defstruct title: nil, image: nil, link: nil

  def home(conn, _params) do
    recipes = Recipes.list_recipes(true, 5)
    wines = Drinking.list_wines(true, 1)

    recipes_reordered = Enum.take(recipes, 3)
    remaining_recipes = Enum.drop(recipes, 3)

    combined_list =
      Enum.concat([
        Enum.map(recipes_reordered, fn recipe ->
          %{title: recipe.title, image: recipe.image, link: "recipes/#{recipe.id}"}
        end),
        Enum.map(wines, fn wine ->
          %{title: wine.title, image: wine.image, link: "wines/#{wine.id}"}
        end),
        Enum.map(remaining_recipes, fn recipe ->
          %{title: recipe.title, image: recipe.image, link: "recipes/#{recipe.id}"}
        end)
      ])

    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, recipes: combined_list)
  end

  def cv(conn, _params) do
    render(conn, :cv, layout: false)
  end
end
