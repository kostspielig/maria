defmodule MariaWeb.CookingLive do
  use MariaWeb, :live_view

  alias Phoenix.LiveView.JS
  alias Maria.Recipes

  def handle_params(params, _uri, socket) do
    query = Map.get(params, "q", nil)
    recipes = if query do Recipes.search(query) else [] end
    list = if query do recipes else Recipes.list_recipes(true) end
    socket = assign(socket, recipes: recipes, list: list, query: query)

    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    socket = assign(socket, recipes: [], list: [], query: nil)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="py-2 px-4 block max-w-md flex-auto mx-auto">
      <button
        type="button"
        class="text-gray-500 bg-white hover:ring-brand ring-gray-300 h-8 w-full items-center gap-2 rounded-full pl-3 pr-3 py-5 text-sm ring-1 transition flex focus:[&:not(:focus-visible)]:outline-none"
        phx-click={open_modal()}
        >
        <svg aria-hidden="true" class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="1.5" viewBox="0 0 24 24">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z">
        </path>
        </svg>
        <%= @query || "Find Recipes..." %>
      </button>
    </div>


    <div class="mt-6 grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-3 gap-4 items-center justify-center">
    <%= for recipe <- @list do %>
      <.card info={recipe} row_click={&JS.navigate(~p"/recipes/#{&1}")}/>
    <% end %>
    </div>

    <div
      id="searchbar-dialog"
      class="hidden fixed inset-0 z-[90]"
      role="dialog"
      aria-modal="true"
      phx-window-keydown={hide_modal()}
      phx-key="escape"
    >
      <div class="fixed inset-0 bg-zinc-400/25 backdrop-blur-sm opacity-100"></div>
      <div class="fixed inset-0 overflow-y-auto px-4 py-4 sm:py-20 sm:px-6 md:py-32 lg:px-8 lg:py-[15vh]">
        <div
          id="searchbox_container"
          class="mx-auto overflow-hidden rounded-3xl bg-zinc-50 shadow-xl ring-zinc-900/7.5 sm:max-w-xl opacity-100 scale-100"
          phx-hook="SearchBar"
        >
          <div
            role="combobox"
            aria-haspopup="listbox"
            phx-click-away={hide_modal()}
            aria-expanded={@recipes != []}
          >
            <form action="" novalidate="" role="search" phx-change="change">
              <div class="group relative flex h-12">
                <svg
                  viewBox="0 0 20 20"
                  fill="none"
                  aria-hidden="true"
                      class="pointer-events-none absolute left-3 top-0 h-full w-5 stroke-zinc-500"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M12.01 12a4.25 4.25 0 1 0-6.02-6 4.25 4.25 0 0 0 6.02 6Zm0 0 3.24 3.25"
                  >
                  </path>
                </svg>

                <input
                  id="search-input"
                  name="q"
                  class="flex-auto rounded-lg appearance-none bg-transparent pl-10 text-zinc-900 outline-none focus:outline-none border-slate-200 focus:border-slate-200 focus:ring-0 focus:shadow-none placeholder:text-zinc-500 focus:w-full focus:flex-none sm:text-sm [&::-webkit-search-cancel-button]:hidden [&::-webkit-search-decoration]:hidden [&::-webkit-search-results-button]:hidden [&::-webkit-search-results-decoration]:hidden pr-4"
                  style={
                    @recipes != [] &&
                      "border-bottom-left-radius: 0; border-bottom-right-radius: 0; border-bottom: none"
                  }
                  aria-autocomplete="both"
                  aria-controls="searchbox__results_list"
                  autocomplete="off"
                  autocorrect="off"
                  autocapitalize="off"
                  enterkeyhint="search"
                  spellcheck="false"
                  placeholder="Find Recipes..."
                  type="search"
                  value=""
                  tabindex="0"
                />
              </div>

              <ul
                :if={@recipes != []}
                class="divide-y divide-slate-200 overflow-y-auto rounded-b-lg border-t border-slate-200 text-sm leading-6"
                id="searchbox__results_list"
                role="listbox"
              >
                <%= for recipe <- @recipes do %>
                  <li id={"#{recipe.id}"}>
                    <.link
                      navigate={~p"/recipes/#{recipe.id}"}
                      class="block p-4 hover:bg-slate-100 focus:outline-none focus:bg-slate-100 focus:text-sky-800"
                    >
                      <div class="ml-1 text-base font-bold"><%= recipe.title %></div>
                      <div class="mt-2"><.tags info={recipe.tags} /></div>
                    </.link>
                  </li>
                <% end %>
              </ul>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end


  def handle_event("change", %{"q" =>  ""}, socket) do
    socket =
      socket
      |> assign(:recipes, [])
      |> assign(:list, Recipes.list_recipes(true))
      |> assign(:query, nil)

    {:noreply, socket}
  end

  def handle_event("change", %{"q" => search_query}, socket) do
    recipes = Recipes.search(search_query)
    socket =
      socket
      |> assign(:recipes, recipes)
      |> assign(:list, recipes)
      |> assign(:query, search_query)

    {:noreply, socket}
  end

  def open_modal(js \\ %JS{}) do
    js
    |> JS.show(
      to: "#searchbox_container",
      transition:
        {"transition ease-out duration-200", "opacity-0 scale-95", "opacity-100 scale-100"}
    )
    |> JS.show(
      to: "#searchbar-dialog",
      transition: {"transition ease-in duration-100", "opacity-0", "opacity-100"}
    )
    |> JS.focus(to: "#search-input")
  end

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(
      to: "#searchbar-searchbox_container",
      transition:
        {"transition ease-in duration-100", "opacity-100 scale-100", "opacity-0 scale-95"}
    )
    |> JS.hide(
      to: "#searchbar-dialog",
      transition: {"transition ease-in duration-100", "opacity-100", "opacity-0"}
    )
  end
end
