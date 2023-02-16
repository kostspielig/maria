defmodule MariaWeb.InputHelpers do
  use Phoenix.HTML

  def create_li(form, field, input_opts \\ [], data \\ []) do
    type = Phoenix.HTML.Form.input_type(form, field)
    name = Phoneix.HTML.Form.input_name(form, field) <> "[]"
    opts = Keyword.put_new(input_opts, :name, name)

    content_tag :li do
      [
        apply(Phoenix.HTML.Form, type, [form, field, opts]),
        link("Remove", to: "#", data: data, title: "Remove", class: "remove-array-item")
      ]
    end
  end
end
