defmodule TorTrackerWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.control_connection_index_path(@socket, :index)}>
        <.live_component
          module={TorTrackerWeb.ControlConnectionLive.FormComponent}
          id={@control_connection.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.control_connection_index_path(@socket, :index)}
          control_connection: @control_connection
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class=" phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="modal-box phx-modal-content "
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal()
          %>
        <% else %>
          <a id="close" href="#" class="btn btn-sm" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def overlay(%{inner_block: _} = assigns) do
~H"""
  <div class="absolute flex items-center justify-center w-full h-full top-0 left-0 bg-black opacity-70">
    <%= render_slot(@inner_block) %>
  </div>
  """
  end

  def tooltip(%{inner_block: _, text: _} = assigns) do
~H"""
    <div class="tooltip h-fit" data-tip={@text}> 
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def format_bytes(0, decimal) do
    "0Bytes"
  end

  def format_bytes(bytes, decimal \\ 2) do
    k = 1024
    sizes = ["Bytes", "KB", "MB"]

    i = trunc(:math.log(bytes) / :math.log(k))

    Float.round(bytes / :math.pow(k, i), decimal)
    bytes 
    |> Kernel./(:math.pow(k, i))
    |> Float.round(decimal)
    |> Float.to_string()
    |> Kernel.<>(Enum.at(sizes, i)) 
  end
end
