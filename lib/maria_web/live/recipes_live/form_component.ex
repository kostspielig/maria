defmodule MariaWeb.RecipesLive.FormComponent do
  use MariaWeb, :live_component

 # import Logger
  alias Maria.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title  %>
        <img src={"#{@recipe.cover}"}>
      </.header>


      <.simple_form
        :let={f}
        for={@changeset}
        id="recipes-form"
        method="post"
        enctype="multipart/form-data"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :title}} type="text" label="Title" />
        <.input field={{f, :description}} type="textarea" label="Description" />
        <.input field={{f, :ingredients}} type="text" label="Ingredients" placeholder="1 egg, 2 tsp sugar" />
        <.input field={{f, :directions}} type="textarea" label="Directions" phx-hook="RecipeDirections" id="product_directions" />
        <.input field={{f, :mins}} type="text" label="Time" placeholder="1d 2h 30m" />
        <.input field={{f, :yield}} type="number" label="Yields" />
        <.input field={{f, :link}} type="text" label="Link" />
        <.input field={{f, :tags}} type="text" label="Tags" placeholder="chinese, korean, spanish, russian" />
        <.input field={{f, :cover}} type="slot" label="Link" >
        <div class="lg:flex lg:items-start">
          <.live_file_input upload={@uploads.cover} class={[
          "mt-2 block w-full min-w-0 flex-auto cursor-pointer rounded border border-solid border-zinc-300",
          "text-zinc-900 sm:text-sm sm:leading-6 rounded-lg py-[7px] px-[11px]",
          "bg-white bg-clip-padding px-3 py-1 text-sm font-normal text-neutral-700 outline-none transition",
          "duration-300 ease-in-out file:-mx-3 file:-my-1.5 file:cursor-pointer file:overflow-hidden file:rounded-none",
          "file:border-0 file:border-solid file:border-inherit file:bg-neutral-100 file:px-3 file:py-1.5 file:text-neutral-700",
          "file:transition file:duration-150 file:ease-in-out file:[margin-inline-end:0.75rem] file:[border-inline-end-width:1px]",
          "hover:file:bg-neutral-200 focus:border-primary focus:bg-white focus:text-neutral-700 focus:shadow-[0_0_0_1px]",
          "focus:shadow-primary focus:outline-none dark:bg-transparent dark:text-neutral-200 dark:focus:bg-transparent"]} />
          <%= for entry <- @uploads.cover.entries do %>
            <div class="mt-8 max-w-sm mx-auto lg:mt-2 lg:ml-2">
            <.live_img_preview entry={entry} class="rounded" />
            <%= for err <- upload_errors(@uploads.cover, entry) do %>
              <.error><%= error_to_string(err) %></.error>
            <% end %>
          </div>
          <% end %>
        </div>
        </.input>
        <:actions>
          <.button phx-disable-with="Saving...">Save Recipe</.button>
        </:actions>
        </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{recipe: recipe} = assigns, socket) do
    changeset = Recipes.change_recipe(recipe)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:uploaded_files, [])
     |> allow_upload(:cover, accept: ~w(.jpg .jpeg .png .gif), max_entries: 1, max_file_size: 2_000_000   )
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      socket.assigns.recipe
      |> Recipes.validate_recipe(recipe_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(socket, socket.assigns.action, recipe_params)
  end

  defp save_recipe(socket, :edit, recipe_params) do
    params =
      recipe_params
      |> add_cover(socket)
      |> Map.put("editor_id", socket.assigns.current_user.id)

    case Recipes.update_recipe(socket.assigns.recipe, socket, params) do
      {:ok, _recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_recipe(socket, :new, recipe_params) do
    params =
      recipe_params
      |> add_cover(socket)
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Recipes.create_recipe(socket, params) do
      {:ok, _recipe} ->
        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def error_to_string(:too_large), do: "File is too large, please select one under 2MB"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  defp add_cover(recipe_params, socket) do
    cover = List.first(socket.assigns.uploads.cover.entries)
    if cover != nil do
      recipe_params
      |> Map.put("cover", cover)
    else
      recipe_params
    end
  end
end
