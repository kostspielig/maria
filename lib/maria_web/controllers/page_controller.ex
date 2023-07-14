defmodule MariaWeb.PageController do
  use MariaWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def maria(conn, _params) do
    render(conn, :maria, layout: false)
  end
end
