defmodule TorTrackerWeb.RelayInfoLive do
  use TorTrackerWeb, :live_view
  alias TorTracker.{Relay, Accounts}

  @impl true
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {:ok, assign_user(socket, token)}
  end

  def assign_user(socket, token) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

end
