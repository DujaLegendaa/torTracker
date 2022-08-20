defmodule TorControl.TelnetClient do
  use GenServer
  alias Phoenix.PubSub
  require Logger

  def start_link(ip, port, pubsub, channel, opts \\ []) do
    GenServer.start_link(__MODULE__, {ip, port, pubsub, channel}, opts)
  end

  def init({ip, port, pubsub, channel}) do
    {:ok, socket} = :gen_tcp.connect(ip, port, [:binary, active: true])
    broadcast_fn = &broadcast(pubsub, channel, &1)
    {:ok, %{socket: socket, broadcast_fn: broadcast_fn} }
  end

  def broadcast(pubsub, channel, message) when message != nil do
    if message != :ok do
      Logger.info("broadcasted #{inspect message}")
      PubSub.broadcast(pubsub, channel, message)
    end
  end

  def broadcast(_pubsub, _channel, message) when message == nil do

  end

  def auth(pid, password) do
    send_data(pid, ['authenticate ', ?", password, ?"])
  end

  def enable_bw(pid) do
    send_data(pid, ['setevents BW'])
  end

  def sync(pid) do
    send_data(pid, ['getconf BandwidthRate'])
    send_data(pid, ['getconf BandwidthBurst'])
    send_data(pid, ['getinfo fingerprint'])
  end

  def send_data(pid, data) do
    Logger.info("Send #{inspect data}")
    data = data ++ ['\n'] 
    GenServer.cast(pid, {:send, data})
  end

  def handle_info({:tcp, _socket, data}, %{broadcast_fn: broadcast_fn} = state) do
    Logger.info("Got #{inspect data}")
    data
    |> split()
    |> Stream.map(&make_message/1)
    |> Stream.map(&broadcast_fn.(&1))
    |> Stream.run()

    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, _state) do
    Process.exit(self(), :normal)
  end

  def split(resp) do
    resp
    |> String.trim("\r\n")
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " "))
    
  end    

  def make_message(["250", "OK"]) do 
    :ok
  end

  def make_message(["515", "Authentication", "failed:" | _rest]) do
    %{authentication: :error}
  end

  def make_message(["650", "BW", read, written]) do
    %{read: read, written: written}
  end

  def make_message(["250", "BandwidthRate=" <> limit]) do
    %{bandwidth_limit: String.to_integer limit}
  end

  def make_message(["250", "BandwidthBurst=" <> burst]) do
    %{bandwidth_burst: String.to_integer burst}
  end

  def make_message(["250-fingerprint=" <> fingerprint]) do
    %{fingerprint: fingerprint}
  end

  def bytes_repr(bytes) do
    {divisor, name} = 
      cond do
        String.to_integer(bytes) > 1024 * 1024 -> 
          {1024 * 1024, "MB"}
        String.to_integer(bytes) > 1024 -> 
          {1024, "KB"}
        true -> 
          {1, "B"} 
      end
     
    bytes 
    |> String.to_integer()
    |> div(divisor)
    |> Integer.to_string()
    |> Kernel.<>(name) 

  end

  defp log(["650", "BW", read, written]) do
    Logger.info("Bandwidth read:#{bytes_repr read} written:#{bytes_repr written}")
  end


  def handle_cast({:send, data}, %{socket: socket} = state) do
    :gen_tcp.send(socket, data)
    {:noreply, state}
  end
  
end
