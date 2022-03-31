defmodule ZiosPizza.Scheduler.Server do
  use GenServer, restart: :transient

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: via_tuple(args))
  end

  def init([scheduled_datetime, order]) do
    time_offset = DateTime.diff(scheduled_datetime, DateTime.utc_now())
    Process.send_after(self(), :check, time_offset * 1000)
    {:ok, [scheduled_datetime, order]}
  end

  def handle_info(:check, state) do
    {:stop, :normal, state}
  end

  defp via_tuple(code) do
    {:via, Registry, {ZiosPizza.Scheduler.Registry, code}}
  end
end
