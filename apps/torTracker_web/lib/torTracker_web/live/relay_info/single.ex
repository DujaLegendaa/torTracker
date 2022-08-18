defmodule TorTrackerWeb.RelayInfoLive.Single do
  use TorTrackerWeb, :live_view

  alias TorTracker.Relay
  alias TorTracker.Relay.Info
  require Logger

  @base_channel "relay_info"

  def get_channel(id) do
    @base_channel <> ":" <> id
  end

  @impl true
  def mount(_params, %{"info_fingerprint" => fingerprint}, socket) do
    if connected?(socket) do
      TorTrackerWeb.Endpoint.subscribe(get_channel(fingerprint))
    end
    {:ok,
      socket
      |> assign_info(fingerprint)
      |> assign_realtime_vars()
      |> assign_control_vars()
    }
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

  @impl true
  def handle_info(%{authentication: :error}, socket) do
    {:noreply, assign(socket, authenticated?: false) |> connect()}
  end

  def handle_info(%{read: read, written: written}, socket) do
    event_name = "new_point:chart:" <> socket.assigns.info.fingerprint
    {:noreply,
      socket
      |> push_event(event_name, %{label: "Read", value: read})
      |> push_event(event_name, %{label: "Write", value: written})
    }
  end

  def connect(socket) do
    %Info{ip: ip, port: port, fingerprint: fingerprint} = socket.assigns.info
    ip = Relay.Info.ip_to_tuple(ip)

    pid = TorControl.connect(ip, port, TorTracker.PubSub, get_channel(fingerprint))

    assign(socket, pid: pid)
  end

  @impl true
  def handle_event("connect", _params, socket) do

    {:noreply, connect(socket)}
  end

  def handle_event("authenticate", %{"password" => password}, socket) do
    Logger.info("trying to authenticate with password #{password}")
    TorControl.authenticate(socket.assigns.pid, password)
    TorControl.enable_bw(socket.assigns.pid)
    {:noreply, assign(socket, authenticated?: true)}
  end



  def stats(%{cpu_usage: _, ram_usage: _, uptime_sec: _} = assigns) do
~H"""
    <div class="stats stats-vertical shadow">
      <div class="stat">
        <div class="stat-figure text-[#843ea8]">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z" />
          </svg>
        </div>
        <div class="stat-title">CPU usage</div>
        <div class="stat-value text-[#843ea8]"><%= @cpu_usage %></div>
      </div>
      <div class="stat">
        <div class="stat-figure text-[#65c3c8]">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
        </svg>
        </div>
        <div class="stat-title">RAM usage</div>
        <div class="stat-value text-[#65c3c8]"><%= @ram_usage %></div>
      </div>
      <div class="stat">
        <div class="stat-figure text-[#65c3c8]">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
          <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </div>
        <div class="stat-title">Uptime</div>
        <div class="stat-value text-[#65c3c8]"><%= @uptime_sec %></div>
      </div>

    </div>
    """
  end

end
