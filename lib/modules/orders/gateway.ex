defmodule ZiosPizza.Orders.Gateway do
  use DynamicSupervisor

  alias ZiosPizza.Orders.Server

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_) do
    {:ok, _} = DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def execute(code, cmd) do
    code
    |> create_if_not_exists
    |> Server.execute(cmd)
  end

  defp create_if_not_exists(code) do
    _ = DynamicSupervisor.start_child(__MODULE__, {ZiosPizza.Orders.Server, [code]})
    code
  end
end
