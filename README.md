# Maria

To start your Maria's App server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit maria's page at [`localhost:4000`](http://localhost:4000).

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


Creating resources:

```
mix phx.gen.html Recipes Recipe recipes title:string descrition:text cover:string directions:text mins:integer ingredients:array:string likes:integer tags:array:string
mix ecto.migrate
``
