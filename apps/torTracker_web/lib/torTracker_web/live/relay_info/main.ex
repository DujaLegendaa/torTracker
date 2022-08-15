defmodule TorTrackerWeb.RelayInfoLive.Main do
  use TorTrackerWeb, :live_view
  alias TorTracker.{Relay, Accounts}

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok,
      socket
      |> assign_info_ids(user_token)
    }
  end

  def assign_info_ids(socket, user_token) do
    assign_new(socket, :info_ids, fn ->
      user_token
      |> Accounts.get_user_by_session_token()
      |> Relay.get_info_ids_by_user() 
    end)
  end

end
