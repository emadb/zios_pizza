defmodule ZiosPizza.Slots.Server do
  use GenServer, restart: :transient
  alias ZiosPizza.Slots.Repo
  alias ZiosPizza.Slots.Slot

  @check_interval 1000 * 60 * 60 * 24

  def start_link([id]) do
    GenServer.start_link(__MODULE__, [id], name: via_tuple(id))
  end

  def init([id]) do
    {:ok, {Slot.initial_state(id, 0, 0), :off}, {:continue, :load}}
  end

  def execute(id, cmd) do
    GenServer.call(via_tuple(id), cmd)
  end

  def handle_continue(:load, {slot, :off}) do
    Process.send_after(self(), :check_tick, @check_interval)

    case Repo.get(slot.datetime) do
      {:ok, slot} -> {:noreply, {slot, :on}}
      :not_found -> {:noreply, {slot, :off}}
    end
  end

  def handle_info(:check_tick, state) do
    stop_or_continue(state)
  end

  def handle_call(:get_slot, _from, {slot, :on} = state) do
    {:reply, {:ok, slot}, state}
  end

  # EMA: Support only.
  def handle_call({:create_or_update, payload}, _from, {slot, status}) do
    new_slot = %Slot{slot | capacity: payload.capacity}
    Repo.upsert(new_slot)

    if Slot.should_die(new_slot) do
      {:stop, :normal, {:ok, slot}, {new_slot, status}}
    else
      {:reply, {:ok, new_slot}, {new_slot, :on}}
    end
  end

  def handle_call({:reserve_slot, payload}, _from, {slot, :on}) do
    case Slot.reserve(slot) do
      {:ok, new_slot} ->
        Repo.upsert(new_slot)

        ZiosPizza.Broker.publish(
          {:slot_reserved, %{user_id: payload.user_id, datetime: new_slot.datetime}}
        )

        {:reply, {:ok, new_slot}, {new_slot, :on}}

      error ->
        {:reply, error, {slot, :on}}
    end
  end

  def handle_call({:reserve_slot, _}, _from, {slot, :off}) do
    {:reply, {:error, "Lo slot non esiste"}, {slot, :off}}
  end

  def handle_call({:release_slot, _}, _from, {slot, :on}) do
    {:ok, new_slot} = Slot.release(slot)
    Repo.upsert(new_slot)
    {:reply, {:ok, new_slot}, {new_slot, :on}}
  end

  defp stop_or_continue({slot, _} = state) do
    if Slot.should_die(slot) do
      {:stop, :normal, state}
    else
      Process.send_after(self(), :check_tick, @check_interval)
      {:noreply, state}
    end
  end

  defp via_tuple(datetime) do
    {:via, Registry, {ZiosPizza.Slots.Registry, datetime}}
  end
end
