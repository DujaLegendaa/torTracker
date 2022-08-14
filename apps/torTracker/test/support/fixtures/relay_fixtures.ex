defmodule TorTracker.RelayFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TorTracker.Relay` context.
  """

  @doc """
  Generate a control_connection.
  """
  def control_connection_fixture(attrs \\ %{}) do
    {:ok, control_connection} =
      attrs
      |> Enum.into(%{
        ip: "some ip",
        name: "some name",
        port: 42
      })
      |> TorTracker.Relay.create_control_connection()

    control_connection
  end

  @doc """
  Generate a unique info fingerprint.
  """
  def unique_info_fingerprint, do: "some fingerprint#{System.unique_integer([:positive])}"

  @doc """
  Generate a info.
  """
  def info_fixture(attrs \\ %{}) do
    {:ok, info} =
      attrs
      |> Enum.into(%{
        bandwidth_burst: 120.5,
        bandwidth_limit: 120.5,
        cpu_usage: 120.5,
        fingerprint: unique_info_fingerprint(),
        flags: [],
        name: "some name",
        ram_usage: 42,
        uptime_sec: 42
      })
      |> TorTracker.Relay.create_info()

    info
  end
end
