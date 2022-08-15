defmodule TorTrackerWeb.RelayInfoLive.Single do
  use TorTrackerWeb, :live_view

  alias TorTracker.Relay
  alias TorTracker.Relay.Info
  require Logger


  @impl true
  def mount(_params, %{"info_fingerprint" => fingerprint}, socket) do
    if connected?(socket) do
      TorTrackerWeb.Endpoint.subscribe("relay_info:" <> fingerprint)
    end
    {:ok, socket |> assign_info(fingerprint) |> assign_realtime_vars() |> assign_control_vars() }
  end

  def assign_info(socket, fingerprint) do
    assign_new(socket, :info, fn ->
      Relay.get_info_by_fingerprint(fingerprint)
    end)
  end

  def assign_realtime_vars(socket) do
    socket
    |> assign_new(:ram_usage, fn -> 0 end)
    |> assign_new(:cpu_usage, fn -> 0.0 end)
    |> assign_new(:uptime_sec, fn -> 0 end)
  end

  def assign_control_vars(socket) do
    socket
    |> assign_new(:pid, fn -> nil end)
    |> assign_new(:authenticated?, fn -> false end)
  end

  def handle_info(%{authentication: :error}, socket) do
    {:noreply, assign(socket, authenticated?: false)}
  end


  @impl true
  def handle_event("connect", _params, socket) do
    %Info{ip: ip, port: port, id: id} = socket.assigns.info
    ip = Relay.Info.ip_to_tuple(ip)
    pid = TorControl.connect(ip, port, id) 
    {:noreply, assign(socket, pid: pid)}
  end

  def handle_event("authenticate", %{"password" => password}, socket) do
    TorControl.authenticate(socket.assigns.pid, password)
    {:noreply, assign(socket, authenticated?: true)}
  end
end
