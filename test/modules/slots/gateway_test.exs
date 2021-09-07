defmodule ZiosPizza.Sots.GatewayTest do
  use ExUnit.Case
  use ZiosPizza.RepoCase
  alias ZiosPizza.Slots.Gateway
  alias ZiosPizza.Slots.Server

  defp tomorrow do
    DateTime.utc_now()
    |> DateTime.add(60 * 60 * 48, :second)
    |> DateTime.truncate(:second)
  end

  defp server_alive?(datetime) do
    if Registry.lookup(ZiosPizza.Slots.Registry, datetime) == [] do
      false
    else
      [{pid, nil}] = Registry.lookup(ZiosPizza.Slots.Registry, datetime)
      Process.alive?(pid)
    end
  end

  describe "Slot function" do
    test "spawn a new slot" do
      datetime = tomorrow() |> DateTime.truncate(:second)
      Gateway.execute(datetime, {:create_or_update, %{capacity: 5}})
      {:ok, state} = Server.execute(datetime, :get_slot)

      assert state.capacity == 5
    end

    test "spawn a new slot: the slot already exists should update its status" do
      datetime = tomorrow() |> DateTime.truncate(:second)
      Gateway.execute(datetime, {:create_or_update, %{capacity: 5}})
      Gateway.execute(datetime, {:create_or_update, %{capacity: 8}})
      {:ok, state} = Server.execute(datetime, :get_slot)

      assert state.capacity == 8
    end

    test "spawn a new slot: if its date in the past should die" do
      datetime =
        DateTime.utc_now()
        |> DateTime.add(-60 * 60 * 24 * 2, :second)
        |> DateTime.truncate(:second)

      {:ok, _} = Gateway.execute(datetime, {:create_or_update, %{capacity: 5}})
      ZiosPizza.DelayAsserts.wait_until(fn -> server_alive?(datetime) == false end)
    end
  end
end
