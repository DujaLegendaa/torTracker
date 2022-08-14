defmodule TorTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TorTracker.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: TorTracker.PubSub}
      # Start a worker by calling: TorTracker.Worker.start_link(arg)
      # {TorTracker.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: TorTracker.Supervisor)
  end
end
