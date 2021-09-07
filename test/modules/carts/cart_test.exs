defmodule ZiosPizza.Carts.CartTest do
  use ExUnit.Case
  alias ZiosPizza.Carts.Cart

  test "initial_state" do
    state = Cart.initial_state(42)
    assert state == %Cart{user_id: 42, pizzas: [], total: 0}
  end

  test "add_pizza" do
    state = Cart.initial_state(42)
    state = Cart.add_pizza(state, %{pizza_id: 1, name: "margherita", qty: 2, price: 400})

    assert state == %Cart{
             user_id: 42,
             total: 800,
             pizzas: [
               %ZiosPizza.Carts.CartItem{
                 pizza_id: 1,
                 qty: 2,
                 name: "margherita",
                 price: 400,
                 total_price: 800
               }
             ]
           }
  end

  test "add_pizza pizza exists, update qty" do
    state =
      Cart.initial_state(42)
      |> Cart.add_pizza(%{pizza_id: 1, qty: 2, name: "margherita", price: 400})
      |> Cart.add_pizza(%{pizza_id: 1, qty: 3, name: "margherita", price: 400})

    assert state == %Cart{
             user_id: 42,
             total: 2000,
             pizzas: [
               %ZiosPizza.Carts.CartItem{
                 pizza_id: 1,
                 qty: 5,
                 name: "margherita",
                 price: 400,
                 total_price: 2000
               }
             ]
           }
  end

  test "add_pizza two different pizzas" do
    state =
      Cart.initial_state(42)
      |> Cart.add_pizza(%{pizza_id: 1, qty: 1, name: "margherita", price: 400})
      |> Cart.add_pizza(%{pizza_id: 2, qty: 2, name: "verdure", price: 600})

    assert state == %Cart{
             user_id: 42,
             total: 1600,
             pizzas: [
               %ZiosPizza.Carts.CartItem{
                 pizza_id: 1,
                 qty: 1,
                 name: "margherita",
                 price: 400,
                 total_price: 400
               },
               %ZiosPizza.Carts.CartItem{
                 pizza_id: 2,
                 qty: 2,
                 name: "verdure",
                 price: 600,
                 total_price: 1200
               }
             ]
           }
  end

  test "set_slot should store slot info" do
    initial_state = %Cart{user_id: 42, reserved_slot: nil, pizzas: []}
    now = DateTime.utc_now()
    state = Cart.set_slot(initial_state, %{datetime: now})
    assert state == %Cart{user_id: 42, reserved_slot: now, pizzas: []}
  end
end
