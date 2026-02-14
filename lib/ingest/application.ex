defmodule Ingest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      IngestWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:ingest, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ingest.PubSub},
      Ingest.Store.Job,
      IngestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ingest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IngestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
