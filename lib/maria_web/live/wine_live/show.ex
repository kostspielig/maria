defmodule MariaWeb.WineLive.Show do
  use MariaWeb, :live_view

  alias Maria.Drinking

  alias MariaWeb.CoreComponentsUp, as: CC

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    wine = Drinking.get_wine!(id)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action, wine.name))
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:wine, wine)}
  end


  defp page_title(:show, title), do: "#{title}"
  defp page_title(:edit, title), do: "Edit #{title}"
end
