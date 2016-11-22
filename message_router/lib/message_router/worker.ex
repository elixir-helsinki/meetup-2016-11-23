defmodule MessageRouter.Worker do

  require Logger
  
  use GenServer

  def start_link(arg1, arg2, arg3) do
    GenServer.start_link(__MODULE__, [arg1, arg2, arg3])
  end
  
  def init(opts) do
    Logger.info "MessageRouter.Worker started."
    {:ok, %{}}
  end
  
end
