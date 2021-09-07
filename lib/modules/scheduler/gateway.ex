defmodule ZiosPizza.Scheduler.Gateway do
  use DynamicSupervisor
  alias ZiosPizza.Scheduler.Server

  def start_link(_) do
    {:ok, _} = DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def schedule(scheduled_time, order) do
    {:ok, _} = DynamicSupervisor.start_child(__MODULE__, {Server, [scheduled_time, order]})
  end

  def restart do
    # cerca sul db tutti gli ordini non ancora preparati e non scaduti e li schedula
  end
end
