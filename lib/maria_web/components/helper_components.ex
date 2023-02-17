defmodule MariaWeb.HelperComponents do
  use Phoenix.Component

  attr :row_click, :any, default: nil
  attr :info, :map, required: true


  def card(assigns) do
    ~H"""
    <div phx-click={@row_click && @row_click.(@info)} class="w-ful border overflow-hidden">
      <div class="pb-8 cursor-pointer">
        <div class={"w-full h-56 bg-brand"}></div>
        <div class="text-2xl font-semibold font-sans mt-4 ml-4 uppercase"><%= @info.title %></div>
        <div class="text-sm font-medium mt-4 ml-4 font-sans capitalize"><%= @info.description %></div>
      </div>
    </div>
    """
  end
end
