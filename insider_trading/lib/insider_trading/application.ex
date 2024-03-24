defmodule InsiderTrading.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      InsiderTradingWeb.Telemetry,
      # Start the Ecto repository
      InsiderTrading.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: InsiderTrading.PubSub},
      # Start Finch
      {Finch, name: InsiderTrading.Finch},
      # Start the Endpoint (http/https)
      InsiderTradingWeb.Endpoint
      # Start a worker by calling: InsiderTrading.Worker.start_link(arg)
      # {InsiderTrading.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InsiderTrading.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InsiderTradingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
