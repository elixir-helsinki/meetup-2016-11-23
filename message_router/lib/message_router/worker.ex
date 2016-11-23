defmodule MessageRouter.Worker do

  alias Romeo.Connection, as: Conn
  alias Romeo.Stanza.Message
  
  require Logger
  
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end
  
  def init(_) do
    Logger.info "MessageRouter.Worker started."

    opts = [
      jid: "639605443504@gcm.googleapis.com",
      host: "fcm-xmpp.googleapis.com",
      password: "AIzaSyBK5thL1PgbV_egETsmk4pFR3x0Czl6TYc",
      port: 5235,
      legacy_tls: true
    ]
    
    {:ok, conn_pid} = Conn.start_link(opts)
    
    {:ok, %{conn_pid: conn_pid}}
  end
  
  def handle_info({:stanza, %Message{} = msg}, state) do
    Logger.debug "Received message: #{inspect msg}"
    {:noreply, state}
  end
  
  def handle_info(_, state) do
    {:noreply, state}
  end
  
end
