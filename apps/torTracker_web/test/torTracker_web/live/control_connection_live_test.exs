defmodule TorTrackerWeb.ControlConnectionLiveTest do
  use TorTrackerWeb.ConnCase

  import Phoenix.LiveViewTest
  import TorTracker.RelayFixtures

  @create_attrs %{ip: "some ip", name: "some name", port: 42}
  @update_attrs %{ip: "some updated ip", name: "some updated name", port: 43}
  @invalid_attrs %{ip: nil, name: nil, port: nil}

  defp create_control_connection(_) do
    control_connection = control_connection_fixture()
    %{control_connection: control_connection}
  end

  describe "Index" do
    setup [:create_control_connection]

    test "lists all control_connections", %{conn: conn, control_connection: control_connection} do
      {:ok, _index_live, html} = live(conn, Routes.control_connection_index_path(conn, :index))

      assert html =~ "Listing Control connections"
      assert html =~ control_connection.ip
    end

    test "saves new control_connection", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.control_connection_index_path(conn, :index))

      assert index_live |> element("a", "New Control connection") |> render_click() =~
               "New Control connection"

      assert_patch(index_live, Routes.control_connection_index_path(conn, :new))

      assert index_live
             |> form("#control_connection-form", control_connection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#control_connection-form", control_connection: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.control_connection_index_path(conn, :index))

      assert html =~ "Control connection created successfully"
      assert html =~ "some ip"
    end

    test "updates control_connection in listing", %{conn: conn, control_connection: control_connection} do
      {:ok, index_live, _html} = live(conn, Routes.control_connection_index_path(conn, :index))

      assert index_live |> element("#control_connection-#{control_connection.id} a", "Edit") |> render_click() =~
               "Edit Control connection"

      assert_patch(index_live, Routes.control_connection_index_path(conn, :edit, control_connection))

      assert index_live
             |> form("#control_connection-form", control_connection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#control_connection-form", control_connection: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.control_connection_index_path(conn, :index))

      assert html =~ "Control connection updated successfully"
      assert html =~ "some updated ip"
    end

    test "deletes control_connection in listing", %{conn: conn, control_connection: control_connection} do
      {:ok, index_live, _html} = live(conn, Routes.control_connection_index_path(conn, :index))

      assert index_live |> element("#control_connection-#{control_connection.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#control_connection-#{control_connection.id}")
    end
  end

  describe "Show" do
    setup [:create_control_connection]

    test "displays control_connection", %{conn: conn, control_connection: control_connection} do
      {:ok, _show_live, html} = live(conn, Routes.control_connection_show_path(conn, :show, control_connection))

      assert html =~ "Show Control connection"
      assert html =~ control_connection.ip
    end

    test "updates control_connection within modal", %{conn: conn, control_connection: control_connection} do
      {:ok, show_live, _html} = live(conn, Routes.control_connection_show_path(conn, :show, control_connection))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Control connection"

      assert_patch(show_live, Routes.control_connection_show_path(conn, :edit, control_connection))

      assert show_live
             |> form("#control_connection-form", control_connection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#control_connection-form", control_connection: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.control_connection_show_path(conn, :show, control_connection))

      assert html =~ "Control connection updated successfully"
      assert html =~ "some updated ip"
    end
  end
end
