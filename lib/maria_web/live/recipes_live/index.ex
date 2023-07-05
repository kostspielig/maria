defmodule MariaWeb.RecipesLive.Index do
  use MariaWeb, :live_view

  alias Maria.Recipes
  alias Maria.Recipes.Recipe
  alias MariaWeb.CoreComponentsUp, as: CC

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :recipes, list_recipes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket
     |> apply_action(socket.assigns.live_action, params)
     |> push_event("clearflash", %{id: "flash"})}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    recipe = Recipes.get_recipe!(id)
    socket
    |> assign(:page_title, "Edit #{recipe.title}")
    |> assign(:recipe, recipe)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe")
    |> assign(:current_user, socket.assigns.current_user)
    |> assign(:recipe, %Recipe{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Recipes")
    |> assign(:recipe, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipe = Recipes.get_recipe!(id)
    {:ok, _} = Recipes.delete_recipe(recipe)

    {:noreply, assign(socket, :recipe, list_recipes())}
  end

  defp list_recipes do
    Recipes.list_recipes()
  end
end
