defmodule TorTrackerWeb.RelayInfoLive.Single do
  use TorTrackerWeb, :live_view

  alias TorTracker.Relay

  @impl true
  def mount(_params, %{"info_id" => info_id}, socket) do
    if connected?(socket) do
      TorTrackerWeb.Endpoint.subscribe("relay_info_realtime:" <> Integer.to_string(info_id))
    end
    {:ok, socket |> assign_info(info_id) |> assign_realtime_vars()}
  end

  def assign_info(socket, info_id) do
    assign_new(socket, :info, fn ->
      Relay.get_info!(info_id)
    end)
  end

  def assign_realtime_vars(socket) do
    socket
    |> assign_new(:ram_usage, fn -> 0 end)
    |> assign_new(:cpu_usage, fn -> 0.0 end)
    |> assign_new(:uptime_sec, fn -> 0 end)
  end

  def handle_info(%{cpu_usage: cpu_usage}, socket) do
    {:noreply, assign(socket, cpu_usage: cpu_usage)}  
  end
end
