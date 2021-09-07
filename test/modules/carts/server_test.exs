defmodule ZiosPizza.Carts.ServerTest do
  use ExUnit.Case
  alias ZiosPizza.Carts.Cart
  alias ZiosPizza.Carts.Gateway
  alias ZiosPizza.Carts.Server

  test "add_pizza should add item to an existing cart" do
    start_supervised!({Server, ["Server_USER_1"]})

    {:ok, state} =
      Server.execute(
        "Server_USER_1",
        {:add_pizza, %{pizza_id: 2, qty: 1, name: "margherita", price: 400}}
      )

    assert Enum.count(state.pizzas) == 1
    stop_supervised!(Server)
  end

  test "get_state should return state informations" do
    start_supervised!({Server, ["Server_USER_2"]})
    {:ok, state} = Server.execute("Server_USER_2", :get_state)
    assert state == %Cart{user_id: "Server_USER_2", pizzas: [], total: 0}
  end

  test "add_pizza should add item to an NON existing cart" do
    Gateway.execute(
      "Server_USER_3",
      {:add_pizza, %{pizza_id: 3, qty: 1, name: "margherita", price: 400}}
    )

    {:ok, state} = Server.execute("Server_USER_3", :get_state)
    assert Enum.count(state.pizzas) == 1
  end

  # test "add_pizza multiple times should update qty" do
  #   start_supervised!({Server, ["USER_1"]})
  #   {:ok, state} = Server.execute("USER_1", {:add_pizza, %{pizza_id: 2, qty: 1}})
  #   {:ok, state} = Server.execute("USER_1", {:add_pizza, %{pizza_id: 2, qty: 3}})
  #   assert Enum.count(state.pizzas) == 1
  #   item = Enum.at(state.pizzas, 0)
  #   assert item.qty == 4
  # end
end
