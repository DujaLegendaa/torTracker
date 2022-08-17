defmodule TorTrackerWeb.RelayInfoLive.New do
  use TorTrackerWeb, :live_view

  alias TorTracker.Relay
  alias TorTracker.Relay.Info

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, %{changeset: Relay.change_info(%Info{})})} 
  end
  
end
