defmodule MariaWeb.ErrorHTMLTest do
  use MariaWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(MariaWeb.ErrorHTML, "404", "html", []) =~ "404"
  end

  test "renders 500.html" do
    assert render_to_string(MariaWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
