defmodule ZiosPizza.Kitchen.PoolSupervisor do
  use Supervisor

  def start_link([children]) do
    Supervisor.start_link(__MODULE__, children, name: __MODULE__)
  end

  def init(children) do
    Supervisor.init(children, strategy: :one_for_one)
  end

  def which do
    Supervisor.which_children(__MODULE__)
  end
end
