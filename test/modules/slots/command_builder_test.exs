defmodule ZiosPizza.Slots.CommandBuilderTest do
  use ExUnit.Case
  alias ZiosPizza.Slots.CommandBuilder

  test "build_reserve_slot_command" do
    {:ok, cmd} = CommandBuilder.build_reserve_slot_command(42)
    {:reserve_slot, %{user_id: user_id}} = cmd
    assert user_id == 42
  end
end
