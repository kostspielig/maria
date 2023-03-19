# Maria

App built using [Phoenix](https://www.phoenixframework.org/) and [Elixir](https://elixir-lang.org/).

# Run locally 📌

To start Maria's App server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit maria's page at [`localhost:4000`](http://localhost:4000).


# Run in production ☁️

We are hosting the [app](https://carras.co/) at Gigalixir- a PaaS built for Elixir.
We use here the free tier that provides  instance with 0.2GB of memory and 1 postgresql database limited to 10,000 rows.
See [console here](https://console.gigalixir.com/).

Steps to deploy ([followed this steps earlier](https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html)):

`git push gigalixir`

If there are changes in the DB run:
`gigalixir run mix ecto.migrate`

To see production logs 💬 run `gigalixir logs`

To connect to prod DB run `gigalixir pg:psql`

Also 👀 [phoenix deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Test 🧪

Run tests in the project with:

`mix test`

To only run specific tests add this tag `@tag runnable: true` before each test and run:

`mix test --only runnable:true`

To get into a console with test environment:

`MIX_ENV=test iex -S mix`

# Mail

We are using [Swoosh](https://hexdocs.pm/swoosh/Swoosh.html) [not yet configured live]

To see mailbox in dev go to: `http://localhost:4000/dev/mailbox/`
or curl: `curl http://localhost:4000/dev/mailbox/json`
