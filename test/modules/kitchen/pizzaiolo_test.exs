defmodule ZiosPizza.Kitchen.PizzaioloTest do
  use ExUnit.Case
  alias ZiosPizza.Kitchen.Pizzaiolo

  describe "Pizzaiolo" do
    test "A" do
      _ = ZiosPizza.Broker.subscribe()
      pizzaiolo = :poolboy.checkout(:pizziolo_worker)

      Pizzaiolo.prepare_order(pizzaiolo, %{})

      receive do
        {:order_ready, p} -> assert p == %{pizzaiolo: pizzaiolo}
      end
    end
  end
end
