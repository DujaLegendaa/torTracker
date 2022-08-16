defmodule TorControl.TelnetClient do
  use GenServer
  require Logger
  alias Phoenix.PubSub

  def start_link(ip, port, pubsub, channel, opts \\ []) do
    GenServer.start_link(__MODULE__, {ip, port, pubsub, channel}, opts)
  end

  def init({ip, port, pubsub, channel}) do
    {:ok, socket} = :gen_tcp.connect(ip, port, [:binary, active: true])
    Logger.info("Connected to #{inspect(ip)}:#{port}")
    broadcast_fn = &broadcast(pubsub, channel, &1)
    {:ok, %{socket: socket, broadcast_fn: broadcast_fn} }
  end

  def broadcast(pubsub, channel, message) when message != nil do
    Logger.info("Broadcasted #{inspect message} to #{inspect channel}")
    PubSub.broadcast(pubsub, channel, message)
  end

  def broadcast(_pubsub, _channel, message) when message == nil do

  end

  def auth(pid, password) do
    send_data(pid, ['authenticate ', ?", password, ?"])
  end

  def enable_bw(pid) do
    send_data(pid, ['setevents BW'])
  end

  def send_data(pid, data) do
    data = data ++ ['\n'] 
    GenServer.cast(pid, {:send, data})
  end

  def handle_info({:tcp, _socket, data}, %{broadcast_fn: broadcast_fn} = state) do

    Logger.info("Recieved #{inspect(data)}")

    data
    |> split()
    |> make_message()
    |> broadcast_fn.()

    {:noreply, state}
  end

  def handle_info({:tcp_closed, _socket}, _state) do
    Process.exit(self(), :normal)
  end

  def split(resp) do
    resp
    |> String.replace("\r\n", " ")
    |> String.trim(" ")
    |> String.split(" ")
    
  end    

  # ["250", "OK", "650", "BW", "1000", "2000"]
  def make_message(["250", "OK" | rest]) do 
    make_message(rest)
  end

  def make_message([]) do
    
  end

  def make_message(["515", "Authentication", "failed:" | _rest]) do
    %{authentication: :error}
  end

  def make_message(["650", "BW", read, written]) do
    %{read: read, written: written}
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
    Logger.info("Sending #{inspect(data)}")
    :gen_tcp.send(socket, data)
    {:noreply, state}
  end
  
end
