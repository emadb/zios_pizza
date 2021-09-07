defmodule ZiosPizza.Slots.Gateway do
  use DynamicSupervisor

  alias ZiosPizza.Slots.Server

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_link(_) do
    {:ok, _} = DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def execute(datetime, cmd) do
    datetime
    |> create_if_not_exists
    |> Server.execute(cmd)
  end

  defp create_if_not_exists(datetime) do
    _ = DynamicSupervisor.start_child(__MODULE__, {ZiosPizza.Slots.Server, [datetime]})
    datetime
  end
end
