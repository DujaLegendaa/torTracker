defmodule TorTrackerWeb.PageController do
  use TorTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
