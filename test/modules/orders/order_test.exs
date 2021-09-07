defmodule ZiosPizza.Orders.OrderTest do
  use ExUnit.Case
  alias ZiosPizza.Orders.Order

  test "generate_new_code" do
    code = Order.generate_new_code()
    assert String.length(code) > 0
  end

  test "create" do
    cart = %{
      user_id: 42,
      reserved_slot: DateTime.utc_now(),
      pizzas: [%{id: 1, total_price: 10}, %{id: 2, total_price: 20}]
    }

    order = Order.create(%Order{code: "CODE_1"}, cart)
    assert order.total_price == 30
  end

  test "valid?" do
    order = %{
      code: "CODE_1",
      user_id: 42,
      date: DateTime.utc_now(),
      reserved_slot: DateTime.utc_now(),
      pizzas: [%{id: 1, total_price: 10}, %{id: 2, total_price: 20}]
    }

    assert Order.valid?(order)
  end

  test "valid?: missing date is not valid" do
    order = %{
      code: "CODE_1",
      user_id: 42,
      date: nil,
      reserved_slot: DateTime.utc_now(),
      pizzas: [%{id: 1, total_price: 10}, %{id: 2, total_price: 20}]
    }

    assert Order.valid?(order) == false
  end

  test "valid?: missing slot is not valid" do
    order = %{
      code: "CODE_1",
      user_id: 42,
      date: DateTime.utc_now(),
      reserved_slot: nil,
      pizzas: [%{id: 1, total_price: 10}, %{id: 2, total_price: 20}]
    }

    assert Order.valid?(order) == false
  end

  test "valid?: missing pizzas is not valid" do
    order = %{
      code: "CODE_1",
      user_id: 42,
      date: DateTime.utc_now(),
      reserved_slot: DateTime.utc_now(),
      pizzas: nil
    }

    assert Order.valid?(order) == false
  end

  test "valid?: empty pizzas is not valid" do
    order = %{
      code: "CODE_1",
      user_id: 42,
      date: DateTime.utc_now(),
      reserved_slot: DateTime.utc_now(),
      pizzas: []
    }

    assert Order.valid?(order) == false
  end
end
