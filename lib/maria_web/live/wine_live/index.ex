defmodule MariaWeb.WineLive.Index do
  use MariaWeb, :live_view

  alias Maria.Drinking
  alias Maria.Drinking.Wine

  alias MariaWeb.CoreComponentsUp, as: CC

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :wines, Drinking.list_wines())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket
    |> apply_action(socket.assigns.live_action, params)
    |> push_event("clearflash", %{id: "flash"})}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    wine = Drinking.get_wine!(id)
    socket
    |> assign(:page_title, "Edit #{wine.name}")
    |> assign(:wine, wine)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Wine")
    |> assign(:wine, %Wine{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Wines")
    |> assign(:wine, nil)
  end

  @impl true
  def handle_info({MariaWeb.WineLive.FormComponent, {:saved, wine}}, socket) do
    wine = Drinking.get_wine!(wine.id)
    {:noreply, stream_insert(socket, :wines, wine, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    wine = Drinking.get_wine!(id)
    {:ok, _} = Drinking.delete_wine(wine)

    {:noreply, stream_delete(socket, :wines, wine)}
  end
end
