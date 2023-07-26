# Maria

App built using [Phoenix](https://www.phoenixframework.org/) and [Elixir](https://elixir-lang.org/).

# Run locally 📌

To start Maria's App server <sup id="db1">[1](#f1)</sup>:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit maria's page at [`localhost:4000`](http://localhost:4000).

We are using amazon S3 to store images. If you want recipe creation/update to work locally you need to
configure a .env file with the AWS credentials [see](https://github.com/kostspielig/maria/blob/main/config/config.exs#L62-L65). Basic configuration should look like:

```
export AWS_ACCESS_KEY_ID="<replace_key_id"
export AWS_SECRET_ACCESS_KEY="<replace_secret_access_key>"
export AWS_REGION="<replace_aws_region>"
```

<b id="f1">1</b> If you are running the app for the first time you will need to configure the DB:
  * Install postgresql and start the service.
  * Configure the DB: `mix ecto.create`.  [↩](#db1)

[See local DB config here](https://github.com/kostspielig/maria/blob/main/config/dev.exs#L4-L11)

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

**Note:** If you wanna use the Logger while executing test, you should use warn level or
above (Logger.warn, Logger.error). [See test config here](config/test.exs#L35)

# Mail

We are using [Swoosh](https://hexdocs.pm/swoosh/Swoosh.html) [not yet configured live]

To see mailbox in dev go to: `http://localhost:4000/dev/mailbox/`
or curl: `curl http://localhost:4000/dev/mailbox/json`

# Error Pages

In `maria/config/dev.exs` set `debug_errors: false` if you want to be able to debug error pages.
