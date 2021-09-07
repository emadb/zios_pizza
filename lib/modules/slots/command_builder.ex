defmodule ZiosPizza.Slots.CommandBuilder do
  def build_reserve_slot_command(user_id) do
    {:ok, {:reserve_slot, %{user_id: user_id}}}
  end
end
