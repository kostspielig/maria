defmodule MariaWeb.HelperComponents do
  use Phoenix.Component
  use Phoenix.HTML

  attr :row_click, :any, default: nil
  attr :info, :map, required: true

  def card(assigns) do
    ~H"""
    <div phx-click={@row_click && @row_click.(@info)} class="w-full overflow-hidden text-center">
      <div class="pb-8 cursor-pointer">
        <div class="w-full h-56 bg-brand overflow-hidden"><img class="object-cover w-full h-full" src={"#{@info.cover}"}></div>
        <div class="text-2xl font-semibold font-head mt-4 ml-4"><%= @info.title %></div>
        <div class="text-sm font-medium mt-1 ml-4 font-sans text-zinc-800">by <span class="font-bold"><%= @info.user.username %></span></div>
      </div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :title, :string, required: true
  end

  def attr_card(assigns) do
    ~H"""
    <div class={["text-white rounded-lg max-w-xl capitalize p-8 bg-gradient-to-r from-brand to-emerald-400", @class]}>
      <h1 class="text-4xl pb-4 font-racing  leading-8">
        <%= @title %>
      </h1>
      <div class="grid grid-cols-1 xs:grid-cols-2">
        <div :for={item <- @item} class="flex fex-row py-1 font-semibold text-sm leading-6 gap-4">
          <p class=""><%= render_slot(item) %></p>
          <p class="p-0.5"><%= item.title %></p>
        </div>
      </div>
    </div>
    """
  end

  attr :icon, :string, required: false
  attr :href, :string, required: true

  slot :inner_block, required: false
  def link_item(assigns) do
    ~H"""
    <div class="mt-2"><span class="font-racing">➭ <%= render_slot(@inner_block) %></span> <%= @icon %>
      <a href={"#{@href}"} target="_blank" class="group">
          <span class="bg-left-bottom bg-gradient-to-r from-skin to-skin bg-[length:100%_6px] bg-no-repeat group-hover:bg-[length:100%_16px] transition-all duration-500 ease-out">
        <%= extract_host(@href) %>
      </span>
      </a>
    </div>
    """
  end


  defp extract_host(url) do
    case URI.parse(url).host do
      nil ->
        url
      host ->
        String.replace_prefix(host, "www.", "")
    end
  end

  def recipe_item(assigns) do
    ~H"""
    <div class="mb-6 text-sm">
      <span class="uppercase font-semibold"> ┃ <%= @tag %></span> — <%= @info %>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :class, :string, default: nil

  slot :inner_block, required: true
  def recipe_list(assigns) do
    ~H"""
    <div class={["mt-10", @class]}>
      <h1 class="text-2xl font-head font-semibold leading-8 text-zinc-800">
        <%= @title %>
      </h1>
      <div class="mt-3 text-lg leading-6 text-zinc-800">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def ingredients(assigns) do
    ~H"""
    <%= if @info do %>
      <ul class="pl-5 list-disc font-serif text-xl">
      <%= for ingredient <- String.split(@info, ",") do %>
        <li class="my-2 capitalize"><%= ingredient %></li>
      <% end %>
      </ul>
    <% end %>
    """
  end

  def tags(assigns) do
    ~H"""
    <%= if @info do %>
      <%= for tag <- String.split(@info, ",") do %>
        <span class="inline-block rounded-full bg-brand text-white text-sm font-semibold px-3 py-1 m-1"><%= String.trim(tag) %></span>
      <% end %>
    <% end %>
    """
  end

  attr :text, :string, required: true
  attr :class, :string, default: nil
  def tag(assigns) do
    ~H"""
       <span class={[@class, "inline-block rounded-full bg-blood text-white text-sm font-semibold px-3 py-1 m-1"]}><%= @text %></span>
    """
  end

  attr :class, :string, default: nil
  def rating(assigns) do
  ~H"""
  <div class={[@class]}>
      <%= for i <- 1..5 do %>
        <.star color={ if i <= @star, do: "#fbb506", else: "#fbb5064f" }/>
      <% end %>
  </div>
  """
  end

  attr :color, :string, default: nil
  def star(assigns) do
    ~H"""
    <svg display="inline" class="inline-block" height="20px" width="20px" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 47.94 47.94" xml:space="preserve" fill={@color}><g stroke-width="0"></g><g stroke-linecap="round" stroke-linejoin="round"></g><g> <path d="M26.285,2.486l5.407,10.956c0.376,0.762,1.103,1.29,1.944,1.412l12.091,1.757 c2.118,0.308,2.963,2.91,1.431,4.403l-8.749,8.528c-0.608,0.593-0.886,1.448-0.742,2.285l2.065,12.042 c0.362,2.109-1.852,3.717-3.746,2.722l-10.814-5.685c-0.752-0.395-1.651-0.395-2.403,0l-10.814,5.685 c-1.894,0.996-4.108-0.613-3.746-2.722l2.065-12.042c0.144-0.837-0.134-1.692-0.742-2.285l-8.749-8.528 c-1.532-1.494-0.687-4.096,1.431-4.403l12.091-1.757c0.841-0.122,1.568-0.65,1.944-1.412l5.407-10.956 C22.602,0.567,25.338,0.567,26.285,2.486z"></path> </g>
    </svg>
    """
  end

  def page_header(assigns) do
    ~H"""
    <header class="px-4 py-6 sm:px-6 lg:px-8 xl:px-28 bg-white sticky top-0 z-10">
      <div class="mx-auto max-w-xl lg:mx-auto">
        <a  href="/"  class="flex md:justify-center text-4xl font-racing font-semibold text-brand bg-white uppercase">
          carras.co
        </a>
      </div>
    </header>
    """
  end
end
