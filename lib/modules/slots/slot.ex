defmodule ZiosPizza.Slots.Slot do
  defstruct [:datetime, :capacity, :reserved]

  def initial_state(datetime, capacity, reserved \\ 0) do
    %__MODULE__{
      datetime: datetime,
      capacity: capacity,
      reserved: reserved
    }
  end

  def reserve(slot) do
    with :ok <- can_reserve?(slot),
         :ok <- is_in_the_future(slot) do
      {:ok,
       %__MODULE__{
         slot
         | reserved: slot.reserved + 1
       }}
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def release(slot) do
    {:ok,
     %__MODULE__{
       slot
       | reserved: slot.reserved - 1
     }}
  end

  def should_die(slot) do
    case is_in_the_future(slot) do
      :ok -> false
      {:error, _} -> true
    end
  end

  def can_reserve?(slot) do
    if slot.reserved < slot.capacity, do: :ok, else: {:error, "Lo slot e' pieno"}
  end

  defp is_in_the_future(slot) do
    case DateTime.compare(slot.datetime, DateTime.utc_now()) do
      :gt -> :ok
      _ -> {:error, "Data nel passato"}
    end
  end
end
