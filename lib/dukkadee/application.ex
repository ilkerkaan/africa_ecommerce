defmodule Dukkadee.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Load environment variables from .env file
    Dukkadee.Env.load_env()

    children = [
      # Start the Telemetry supervisor
      DukkadeeWeb.Telemetry,
      # Start the Ecto repository
      Dukkadee.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dukkadee.PubSub},
      # Start the Presence supervisor
      DukkadeeWeb.Presence,
      # Start Finch
      {Finch, name: Dukkadee.Finch},
      # Start the Endpoint (http/https)
      DukkadeeWeb.Endpoint
      # Start a worker by calling: Dukkadee.Worker.start_link(arg)
      # {Dukkadee.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dukkadee.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DukkadeeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
