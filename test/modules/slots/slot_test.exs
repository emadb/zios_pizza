defmodule ZiosPizza.Slots.SlotTest do
  use ExUnit.Case
  alias ZiosPizza.Slots.Slot

  test "reserve slot: operation succeed" do
    two_hours = DateTime.utc_now() |> DateTime.add(60 * 60 * 2) |> DateTime.truncate(:second)
    slot = Slot.initial_state(two_hours, 5)

    {:ok, new_slot} = Slot.reserve(slot)

    assert %Slot{
             datetime: ^two_hours,
             capacity: 5,
             reserved: 1
           } = new_slot
  end

  test "reserve slot: slot is full should fail" do
    two_hours = DateTime.utc_now() |> DateTime.add(60 * 60 * 2) |> DateTime.truncate(:second)
    slot = Slot.initial_state(two_hours, 5, 5)
    {:error, _} = Slot.reserve(slot)
  end

  test "reserve slot: datetime in the past, should fail" do
    yesterday = DateTime.utc_now() |> DateTime.add(-60 * 60 * 24) |> DateTime.truncate(:second)
    slot = Slot.initial_state(yesterday, 5)
    {:error, _} = Slot.reserve(slot)
  end

  test "reserve slot: datetime in too in the future, should fail" do
    future = DateTime.utc_now() |> DateTime.add(60 * 60 * 24 * 30) |> DateTime.truncate(:second)
    slot = Slot.initial_state(future, 5)
    {:ok, _} = Slot.reserve(slot)
  end

  test "should die: datetime is in range should return false" do
    tomorrow = DateTime.utc_now() |> DateTime.add(60 * 60 * 48) |> DateTime.truncate(:second)
    slot = Slot.initial_state(tomorrow, 5, 5)
    res = Slot.should_die(slot)
    assert res == false
  end

  test "should die: datetime is in the past should return true" do
    tomorrow = DateTime.utc_now() |> DateTime.add(-60 * 60 * 24) |> DateTime.truncate(:second)
    slot = Slot.initial_state(tomorrow, 5, 5)
    res = Slot.should_die(slot)
    assert res == true
  end

  test "release: should remove user and decrease reserved" do
    tomorrow = DateTime.utc_now() |> DateTime.add(60 * 60 * 48) |> DateTime.truncate(:second)
    slot = Slot.initial_state(tomorrow, 5)

    {:ok, new_slot} = Slot.reserve(slot)
    {:ok, new_slot} = Slot.reserve(new_slot)

    {:ok, new_slot} = Slot.release(new_slot)

    assert %Slot{
             datetime: ^tomorrow,
             capacity: 5,
             reserved: 1
           } = new_slot
  end
end
