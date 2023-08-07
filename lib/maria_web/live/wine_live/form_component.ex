defmodule MariaWeb.WineLive.FormComponent do
  use MariaWeb, :live_component

  alias MariaWeb.CoreComponentsUp, as: CC
  alias Maria.Drinking

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <CC.header>
        <%= @title %>
      </CC.header>

      <CC.simple_form
        for={@form}
        id="wine-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <CC.input field={@form[:title]} type="text" label="Title" required />
        <CC.input field={@form[:description]} type="textarea" label="Description" required phx-hook="WineDescription" id="wine_description" />

        <div class="grid grid-cols-2 gap-4">
        <CC.input field={@form[:vintage]} type="number" label="Vintage" required />
        <CC.input field={@form[:alcohol]} type="number" label="Alcohol" step="any" />
        </div>
        <div class="grid grid-cols-2 gap-4">
        <CC.input field={@form[:color]} type="select" label="Color" required options={[{"White", "white"}, {"Rose", "rose"}, {"Red", "red"}, {"Orange", "orange"}, {"Bubbles", "bubbles"}, {"Sweet", "sweet"}, {"Fino", "fino"}]} />
        <CC.input field={@form[:grapes]} type="text" label="Grapes" />
        </div>
        <div class="grid grid-cols-2 gap-4">
          <CC.input field={@form[:sweetness]} type="select" label="Sweetness" options={[{"Bone Dry", "bone dry"}, {"Dry", "dry"}, {"Medium", "medium"}, {"Sweet", "sweet"}, {"Very Sweet", "very sweet"}]} />
          <CC.input field={@form[:body]} type="select" label="Body" options={[{"Very Light", "very light"}, {"Light", "light"}, {"Medium", "medium"}, {"Full Bodied", "full bodied"}, {"Heavy", "heavy"}]} />
        </div>

        <div class="grid grid-cols-2 gap-4">
          <CC.input field={@form[:region]} type="text" label="Region" />
          <CC.input field={@form[:country]} type="text" label="Country" />
        </div>
        <CC.input field={@form[:producer]} type="text" label="Producer" />

        <div class="grid grid-cols-2 gap-4">
          <CC.input field={@form[:rating]} type="number" label="Rating" min="0" max="5" step="1" />
          <CC.input field={@form[:price]} type="number" label="Price" step="any" />
        </div>
        <CC.input field={@form[:buy_link]} type="text" label="Buy link" />
        <CC.input field={@form[:image]} type="text" label="Image" />
        <CC.input field={@form[:is_featured]} type="checkbox" label="Is featured ⚡" />
        <CC.input field={@form[:is_draft]} type="checkbox" label="Keep me as a draft 🚧" />
        <CC.input field={@form[:is_good_next_day]} type="checkbox" label="Is good the next day? ⏳" />
        <CC.input field={@form[:food_pairig]} type="text" label="Food pairig" />
        <:actions>
          <CC.button phx-disable-with="Saving...">Save Wine</CC.button>
        </:actions>
      </CC.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{wine: wine} = assigns, socket) do
    changeset = Drinking.change_wine(wine)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"wine" => wine_params}, socket) do
    changeset =
      socket.assigns.wine
      |> Drinking.change_wine(wine_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"wine" => wine_params}, socket) do
    save_wine(socket, socket.assigns.action, wine_params)
  end

  defp save_wine(socket, :edit, wine_params) do
    params =
      wine_params
      |> Map.put("editor_id", socket.assigns.current_user.id)

    case Drinking.update_wine(socket.assigns.wine, params) do
      {:ok, wine} ->
        notify_parent({:saved, wine})

        {:noreply,
         socket
         |> put_flash(:info, "Wine updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_wine(socket, :new, wine_params) do
    params =
      wine_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Drinking.create_wine(params) do
      {:ok, wine} ->
        notify_parent({:saved, wine})

        {:noreply,
         socket
         |> put_flash(:info, "Wine created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
