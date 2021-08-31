defmodule ZiosPizza.Broker do
  @topic :zios_pizza

  def publish(message) do
    Registry.dispatch(ZiosPizza.PubSub.Registry, @topic, fn entries ->
      for {pid, _} <- entries do
        send(pid, message)
      end
    end)
  end

  def subscribe do
    Registry.register(ZiosPizza.PubSub.Registry, @topic, [])
  end
end
