defmodule TorTracker.RelayTest do
  use TorTracker.DataCase

  alias TorTracker.Relay

  describe "control_connections" do
    alias TorTracker.Relay.ControlConnection

    import TorTracker.RelayFixtures

    @invalid_attrs %{ip: nil, name: nil, port: nil}

    test "list_control_connections/0 returns all control_connections" do
      control_connection = control_connection_fixture()
      assert Relay.list_control_connections() == [control_connection]
    end

    test "get_control_connection!/1 returns the control_connection with given id" do
      control_connection = control_connection_fixture()
      assert Relay.get_control_connection!(control_connection.id) == control_connection
    end

    test "create_control_connection/1 with valid data creates a control_connection" do
      valid_attrs = %{ip: "some ip", name: "some name", port: 42}

      assert {:ok, %ControlConnection{} = control_connection} = Relay.create_control_connection(valid_attrs)
      assert control_connection.ip == "some ip"
      assert control_connection.name == "some name"
      assert control_connection.port == 42
    end

    test "create_control_connection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Relay.create_control_connection(@invalid_attrs)
    end

    test "update_control_connection/2 with valid data updates the control_connection" do
      control_connection = control_connection_fixture()
      update_attrs = %{ip: "some updated ip", name: "some updated name", port: 43}

      assert {:ok, %ControlConnection{} = control_connection} = Relay.update_control_connection(control_connection, update_attrs)
      assert control_connection.ip == "some updated ip"
      assert control_connection.name == "some updated name"
      assert control_connection.port == 43
    end

    test "update_control_connection/2 with invalid data returns error changeset" do
      control_connection = control_connection_fixture()
      assert {:error, %Ecto.Changeset{}} = Relay.update_control_connection(control_connection, @invalid_attrs)
      assert control_connection == Relay.get_control_connection!(control_connection.id)
    end

    test "delete_control_connection/1 deletes the control_connection" do
      control_connection = control_connection_fixture()
      assert {:ok, %ControlConnection{}} = Relay.delete_control_connection(control_connection)
      assert_raise Ecto.NoResultsError, fn -> Relay.get_control_connection!(control_connection.id) end
    end

    test "change_control_connection/1 returns a control_connection changeset" do
      control_connection = control_connection_fixture()
      assert %Ecto.Changeset{} = Relay.change_control_connection(control_connection)
    end
  end

  describe "info" do
    alias TorTracker.Relay.Info

    import TorTracker.RelayFixtures

    @invalid_attrs %{bandwidth_burst: nil, bandwidth_limit: nil, cpu_usage: nil, fingerprint: nil, flags: nil, name: nil, ram_usage: nil, uptime_sec: nil}

    test "list_info/0 returns all info" do
      info = info_fixture()
      assert Relay.list_info() == [info]
    end

    test "get_info!/1 returns the info with given id" do
      info = info_fixture()
      assert Relay.get_info!(info.id) == info
    end

    test "create_info/1 with valid data creates a info" do
      valid_attrs = %{bandwidth_burst: 120.5, bandwidth_limit: 120.5, cpu_usage: 120.5, fingerprint: "some fingerprint", flags: [], name: "some name", ram_usage: 42, uptime_sec: 42}

      assert {:ok, %Info{} = info} = Relay.create_info(valid_attrs)
      assert info.bandwidth_burst == 120.5
      assert info.bandwidth_limit == 120.5
      assert info.cpu_usage == 120.5
      assert info.fingerprint == "some fingerprint"
      assert info.flags == []
      assert info.name == "some name"
      assert info.ram_usage == 42
      assert info.uptime_sec == 42
    end

    test "create_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Relay.create_info(@invalid_attrs)
    end

    test "update_info/2 with valid data updates the info" do
      info = info_fixture()
      update_attrs = %{bandwidth_burst: 456.7, bandwidth_limit: 456.7, cpu_usage: 456.7, fingerprint: "some updated fingerprint", flags: [], name: "some updated name", ram_usage: 43, uptime_sec: 43}

      assert {:ok, %Info{} = info} = Relay.update_info(info, update_attrs)
      assert info.bandwidth_burst == 456.7
      assert info.bandwidth_limit == 456.7
      assert info.cpu_usage == 456.7
      assert info.fingerprint == "some updated fingerprint"
      assert info.flags == []
      assert info.name == "some updated name"
      assert info.ram_usage == 43
      assert info.uptime_sec == 43
    end

    test "update_info/2 with invalid data returns error changeset" do
      info = info_fixture()
      assert {:error, %Ecto.Changeset{}} = Relay.update_info(info, @invalid_attrs)
      assert info == Relay.get_info!(info.id)
    end

    test "delete_info/1 deletes the info" do
      info = info_fixture()
      assert {:ok, %Info{}} = Relay.delete_info(info)
      assert_raise Ecto.NoResultsError, fn -> Relay.get_info!(info.id) end
    end

    test "change_info/1 returns a info changeset" do
      info = info_fixture()
      assert %Ecto.Changeset{} = Relay.change_info(info)
    end
  end
end
