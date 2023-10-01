defmodule MariaWeb.HelperComponents do
  use Phoenix.Component
  use Phoenix.HTML

  attr :row_click, :any, default: nil
  attr :info, :map, required: true

  def card(assigns) do
    ~H"""
    <div phx-click={@row_click && @row_click.(@info)} class="w-full overflow-hidden text-center">
      <div class="card pb-8 cursor-pointer">
        <div class="card-img relative w-full h-56 bg-brand overflow-hidden "><img class="object-cover w-full h-full" src={"#{@info.image}"}></div>
        <div class="card-title text-2xl font-semibold font-head mt-4 ml-4"><%= @info.title %></div>
        <div class="text-sm font-medium mt-1 ml-4 font-sans text-zinc-800">by <span class="font-bold"><%= @info.user.username %></span></div>
      </div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :title_link, :string, default: nil
  attr :subtitle, :string, default: nil
  attr :items, :map, required: true
  attr :item_click, :any, default: nil
  attr :color, :string, default: "blood"
  attr :class, :string, default: nil
  attr :img_height, :integer, default: 60 # max-h-80
  attr :next_link, :string, default: nil

  def carousel(assigns) do
    ~H"""
    <div class={["px-6 py-8 mx-auto max-w-2xl sm:max-w-4xl xl:max-w-7xl", @class]}>
      <a class={"font-head text-2xl font-bold text-#{@color}"} href={@title_link}><%= @title %> </a>
      <%= if @subtitle do %><h2 class="mt-8 text-base font-normal"><%= @subtitle %></h2> <% end %>
      <.carousel_items
          items={@items}
          next_link={@next_link}
          img_height={@img_height}
      />
    </div>
    """
  end

  attr :items, :map, required: true
  attr :item_click, :any, default: nil
  attr :img_height, :integer, default: 60 # max-h-80 max-h-60
  attr :next_link, :string, default: nil

  def carousel_items(assigns) do
    ~H"""
      <div class="overflow-x-auto flex">
        <%= for info <- @items do %>
          <div class="flex-none py-6 px-3 first:pl-0 last:pr-6">
            <a  href={info.link} class="cursor-pointer">
            <img class={"max-h-#{@img_height} mx-auto"} src={"#{info.image}"}>
            <%= if info.title do %>
              <div class="block w-72 mt-4">
                <.link_hover color="green"><div class={"inline leading-6 font-serif font-semibold text-lg"}><%= info.title %></div></.link_hover>
               </div>
            <% end %>
            </a>
          </div>
        <% end %>
        <%= if @next_link do %>
          <div class="flex-none py-6 px-3 first:pl-0 last:pr-6 flex justify-center items-center">
            <.link_hover color="green"  href={@next_link} class="cursor-pointer font-racing">more ❯</.link_hover>
          </div>
        <% end %>
      </div>
    """
  end

  attr :title, :string, required: true
  attr :class, :string, default: nil
  attr :from, :string, default: "skin-lighter" # tailwind: from-skin-lighter from-green
  attr :to, :string, default: "skin-lighter"   # tailwind: to-skin-lighter to-green

  slot :item, required: true do
    attr :title, :string, required: true
    attr :suffix, :string, required: false
  end

  def attr_card(assigns) do
    ~H"""
    <div class={["text-black max-w-xl capitalize px-6 py-8 xs:p-8 bg-gradient-to-r from-#{@from} to-#{@to}", @class]}>
      <h1 class="text-4xl pb-4 font-racing  leading-8">
        <%= @title %>
      </h1>
      <div class="grid grid-cols-1 xs:grid-cols-2">
        <div :for={item <- @item} class="flex fex-row py-1 text-sm leading-6 gap-4">
          <p class=""><%= render_slot(item) %></p>
          <p class="p-0.5"><%= item.title %> <%= Map.get(item, :suffix, "") %></p>
        </div>
      </div>
    </div>
    """
  end

  attr :icon, :string, required: false
  attr :href, :string, required: true
  attr :class, :string, default: nil

  slot :inner_block, required: false
  def question_item(assigns) do
    ~H"""
    <div class={["mt-2", @class]}><span class="font-racing">➭ <%= render_slot(@inner_block) %></span> <%= @icon %>
      <.link_hover href={@href} color="green">
        <%= extract_host(@href) %>
      </.link_hover>
    </div>
    """
  end

  attr :href, :string, default: nil
  attr :class, :string, default: nil
  attr :target, :string, default: "_self"
  attr :color, :string, default: "blood" # tailwind: from-green to-green from-blood to-blood from-skin to-skin from-brand to-brand

  slot :inner_block, required: true
  def link_hover(assigns) do
    ~H"""
    <a class={["group transition-all duration-300 ease-in-out", @class]} href={@href} target={@target}>
      <span class={"bg-left-bottom bg-gradient-to-r from-#{@color} to-#{@color} bg-[length:0%_33%] bg-no-repeat [@media(hover:none)]:bg-[length:100%_33%] group-hover:bg-[length:100%_33%] transition-all duration-500 ease-out"}>
        <%= render_slot(@inner_block) %>
      </span>
    </a>
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
    <div class="mb-6 text-sm inline-block pr-2">
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


  attr :text, :string, required: true
  attr :class, :string, default: "bg-blood !text-white"
  def tag(assigns) do
    ~H"""
       <span class={[@class, "inline-block rounded-full text-black text-sm font-semibold px-3 py-1 m-1"]}><%= @text %></span>
    """
  end

  attr :info, :map, required: true
  attr :href, :string, default: nil
  attr :class, :string, default: "bg-brand !text-white"
  def tags(assigns) do
    ~H"""
    <%= if @info do %>
    <%= for tag <- String.split(@info, ",") do %>
      <%= if @href do %>
        <a href={if @href != nil, do: @href <> String.trim(tag), else: ""}><MariaWeb.HelperComponents.tag text={String.trim(tag)} class={@class}/></a>
      <% else %>
        <MariaWeb.HelperComponents.tag text={String.trim(tag)} class={@class}/>
      <% end %>
    <% end %>
    <% end %>
    """
  end

  attr :color, :string, default: "white" # tailwind: fill-red fill-orange fill-sweet fill-bubbles fill-fino fill-rose
  def wine_color(assigns) do
    ~H"""
      <svg class="fill-black" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="30px" height="30px" viewBox="0 0 590.754 590.754" xml:space="preserve"><g><g><path d="M563.732,385.373c-7.206,0-13.99,2.807-19.101,7.904l-47.91,47.91c-2.311,2.311-5.386,3.583-8.654,3.583c-3.268,0-6.343-1.275-8.656-3.586l-97.021-97.021c-5.062-5.062-5.651-14.312-1.347-21.059c18.253-28.596,28.201-61.255,28.771-94.447c0.792-46.236-25.426-102.036-70.139-149.267c-44.678-47.194-99.266-76.797-146.02-79.19l-3.984-0.192L189.452,0h-0.272c-2.161,0-7.895,0-25.539,17.644L17.645,163.64c-18.039,18.036-17.739,23.669-17.613,26.074l0.208,3.954c2.338,46.374,31.576,100.646,78.211,145.154c46.598,44.475,101.953,71.022,148.073,71.022c0.707,0,1.401-0.006,2.105-0.018c33.198-0.585,65.869-10.536,94.486-28.786c2.877-1.833,6.426-2.843,9.997-2.843c4.431,0,8.363,1.493,11.074,4.205l97.023,97.023c2.313,2.312,3.586,5.385,3.586,8.656s-1.272,6.344-3.583,8.653l-47.901,47.904c-5.11,5.096-7.929,11.883-7.929,19.101c0,7.219,2.818,14.006,7.935,19.11c5.096,5.095,11.876,7.903,19.086,7.903c7.206,0,13.987-2.806,19.101-7.903l63.057-63.058l5.741-5.756l82.546-82.547c10.533-10.532,10.533-27.668,0-38.201C577.723,388.18,570.938,385.373,563.732,385.373z M355.787,227.756c-0.542,32.261-14.789,64.694-39.089,88.976c-24.29,24.271-56.719,38.513-88.978,39.07c-0.428,0.006-0.869,0.009-1.3,0.009c-28.66,0-64.367-16.179-97.966-44.382c-32.843-27.574-58.679-62.908-69.104-94.518c-2.369-7.179,1.533-20.107,8.026-26.601L190.349,67.338c4.972-4.973,14.266-8.724,21.616-8.724c1.888,0,3.562,0.239,4.979,0.704C285.432,81.95,356.8,168.529,355.787,227.756z"/><path class={"fill-"<>@color} d="M229.712,340.694c56.65-0.955,111.855-56.157,112.822-112.81l-257.701-1.307C99.004,288.555,172.567,341.683,229.712,340.694z"/></g></g></svg>
    """
  end

  attr :star, :integer, default: 0
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

  attr :color, :string, default: "text-brand"
  def page_header(assigns) do
    ~H"""
    <header class="px-4 py-6 sm:px-6 lg:px-8 xl:px-28 bg-white sticky top-0 z-[60]">
      <div class="mx-auto max-w-xl lg:mx-auto">
        <a  href="/"  class={[@color, "flex md:justify-center text-4xl font-racing font-semibold text-brand bg-white uppercase"]}>
          carras.co
        </a>
      </div>
    </header>
    """
  end
end
