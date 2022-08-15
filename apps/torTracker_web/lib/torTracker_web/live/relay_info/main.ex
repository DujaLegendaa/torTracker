defmodule TorTrackerWeb.RelayInfoLive.Main do
  use TorTrackerWeb, :live_view
  alias TorTracker.{Relay, Accounts}

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok,
      socket
      |> assign_info_fingerprints(user_token)
    }
  end

  def assign_info_fingerprints(socket, user_token) do
    assign_new(socket, :info_fingerprints, fn ->
      user_token
      |> Accounts.get_user_by_session_token()
      |> Relay.get_info_fingerprints_by_user() 
    end)
  end

end
