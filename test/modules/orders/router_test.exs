defmodule ZiosPizza.Orders.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase
  alias ZiosPizza.Carts.Gateway, as: CartGateway
  alias ZiosPizza.Orders.Gateway, as: OrderGateway

  def three_hours_from_now do
    DateTime.add(DateTime.utc_now(), 60 * 60 * 3)
  end

  describe "Orders router" do
    test "GET /orders/:code should return the order details" do
      token = "10000000-0000-0000-0000-000000000001"

      cart = %ZiosPizza.Carts.Cart{
        user_id: token,
        pizzas: [
          %ZiosPizza.Carts.CartItem{
            pizza_id: 1,
            qty: 2,
            name: "margherita",
            price: 400,
            total_price: 800
          }
        ],
        reserved_slot: three_hours_from_now()
      }

      OrderGateway.execute(
        token,
        {:create_order, %{user_id: token, payment_token: "ABC", cart: cart}}
      )

      conn =
        conn(:get, "/orders/#{token}")
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer " <> token)
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert %{
               "code" => "10000000-0000-0000-0000-000000000001",
               "reserved_slot" => _,
               "total_price" => 800
             } = res
    end

    test "POST /orders should create an order" do
      token = "10000000-0000-0000-0000-000000000002"

      CartGateway.execute(
        token,
        {:add_pizza, %{pizza_id: 2, qty: 1, name: "margherita", price: 400}}
      )

      CartGateway.execute(token, {:set_slot, %{datetime: three_hours_from_now()}})

      conn =
        conn(:post, "/orders", %{payment_token: "ABC"})
        |> put_req_header("content-type", "application/json")
        |> put_req_header("authorization", "Bearer " <> token)
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert %{
               "code" => _,
               "reserved_slot" => _,
               "total_price" => 400
             } = res
    end
  end
end
