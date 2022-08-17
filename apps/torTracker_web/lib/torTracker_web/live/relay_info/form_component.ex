defmodule TorTrackerWeb.RelayInfoLive.FormComponent do
  use TorTrackerWeb, :live_component

  alias TorTracker.Relay
  def mount(socket) do
    {:ok, assign(socket, %{changeset: Relay.change_info(%Relay.Info{})})}
  end
  
end
