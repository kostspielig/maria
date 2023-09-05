defmodule MariaWeb.RecipesLive.Show do
  use MariaWeb, :live_view_basic

  alias Maria.Recipes
  alias MariaWeb.CoreComponentsUp, as: CC

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    recipe = Recipes.get_recipe!(id)
    related = Enum.map(Recipes.related(recipe, 4), fn recipe ->
      %{title: recipe.title, image: recipe.image, link: "/recipes/#{recipe.id}"}
    end)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, recipe.title))
     |> assign(:page_og,  %{url: url(~p"/recipes/#{id}"), image: recipe.image, description: Floki.text(recipe.description)})
     |> assign(:recipe, recipe)
     |> assign(:related, related)
     |> push_event("clearflash", %{id: "flash"})}
  end

  defp page_title(:show, title), do: "#{title}"
  defp page_title(:edit, title), do: "Edit #{title}"
end
