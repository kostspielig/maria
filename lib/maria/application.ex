defmodule Maria.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MariaWeb.Telemetry,
      # Start the Ecto repository
      Maria.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Maria.PubSub},
      # Start Finch
      {Finch, name: Maria.Finch},
      # Start the Endpoint (http/https)
      MariaWeb.Endpoint,
      #start cache for HTTP requests
      {Cachex, name: :http_cache}
      # Start a worker by calling: Maria.Worker.start_link(arg)
      # {Maria.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Maria.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MariaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
