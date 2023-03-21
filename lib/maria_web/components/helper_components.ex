defmodule MariaWeb.HelperComponents do
  use Phoenix.Component

  attr :row_click, :any, default: nil
  attr :info, :map, required: true


  def card(assigns) do
    ~H"""
    <div phx-click={@row_click && @row_click.(@info)} class="w-ful border overflow-hidden">
      <div class="pb-8 cursor-pointer">
        <div class="w-full h-56 bg-brand overflow-hidden"><img class="object-cover w-full h-full" src={"#{@info.cover}"}></div>
        <div class="text-2xl font-semibold font-head mt-4 ml-4"><%= @info.title %></div>
        <div class="text-sm font-medium mt-2 ml-4 font-sans capitalize"><%= @info.description %></div>
      </div>
    </div>
    """
  end

  def ingredients(assigns) do
    ~H"""
    <%= for ingredient <- String.split(@info, ",") do %>
      <div class=""><%= ingredient %></div>
    <% end %>
    """
  end

  def tags(assigns) do
    ~H"""
    <%= for tag <- String.split(@info, ",") do %>
      <span class="rounded-full bg-brand text-white text-semibold px-3 py-1 m-2">
        <%= tag %>
      </span>
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
