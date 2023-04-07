defmodule MariaWeb.HelperComponents do
  use Phoenix.Component

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
    <ul class="pl-5 list-disc font-serif text-xl">
    <%= for ingredient <- String.split(@info, ",") do %>
      <li class="my-2 capitalize"><%= ingredient %></li>
    <% end %>
    </ul>
    """
  end

  def tags(assigns) do
    ~H"""
    <%= for tag <- String.split(@info, ",") do %>
      <span class="inline-block rounded-full bg-brand text-white text-sm font-semibold px-3 py-1 m-1"><%= String.trim(tag) %></span>
    <% end %>
    """
  end

  def page_header(assigns) do
    ~H"""
    <header class="px-4 py-6 sm:px-6 lg:px-8 xl:px-28 bg-white sticky top-0">
      <div class="mx-auto max-w-xl lg:mx-auto">
        <a  href="/"  class="flex md:justify-center text-4xl font-racing font-semibold text-brand bg-white uppercase">
          carras.co
        </a>
      </div>
    </header>
    """
  end
end
