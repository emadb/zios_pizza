defmodule ZiosPizza.Cart.Server do
  use GenServer

  def start_link(user_id) do
    GenServer.start_link(__MODULE__, user_id, name: via_tuple(user_id))
  end

  def init(user_id) do
  end

  def execute(id, cmd) do
    GenServer.call(via_tuple(id), cmd)
  end

  defp via_tuple(user_id) do
    {:via, Registry, {ZiosPizza.Cart.Registry, user_id}}
  end
end
