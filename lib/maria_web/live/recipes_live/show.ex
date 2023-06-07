defmodule MariaWeb.RecipesLive.Show do
  use MariaWeb, :live_view_basic

  alias Maria.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    recipe = Recipes.get_recipe!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, recipe.title))
     |> assign(:recipe, recipe)}
  end

  defp page_title(:show, title), do: "#{title}"
  defp page_title(:edit, title), do: "Edit #{title}"
end
