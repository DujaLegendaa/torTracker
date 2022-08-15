defmodule TorControl do
  @moduledoc """
  Documentation for `TorControl`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TorControl.hello()
      :world

  """
  alias TorControl.TelnetClient


  def connect(ip, port, id) do
    case TelnetClient.start_link(ip, port, id) do
      {:ok, pid} ->
        pid
    end
  end

  def authenticate(pid, password) do
    TelnetClient.auth(pid, password)
  end
end
