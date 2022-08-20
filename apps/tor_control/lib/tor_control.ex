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


  def connect(ip, port, pubsub, channel) do
    case TelnetClient.start_link(ip, port, pubsub, channel) do
      {:ok, pid} ->
        pid
    end
  end

  def authenticate(pid, password) do
    TelnetClient.auth(pid, password)
  end

  def enable_bw(pid) do
    TelnetClient.enable_bw(pid)
  end

  def sync(pid) do
    TelnetClient.sync(pid)
  end
end
