defmodule ZiosPizza.Carts.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  alias ZiosPizza.Carts.Server

  describe "Cart router" do
    test "POST /cart should create a new cart" do
      conn =
        conn(:post, "/cart", %{pizza_id: 2})
        |> put_req_header("authorization", "Bearer USER_1")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert conn.status == 201
      assert Enum.count(res["pizzas"]) == 1
      item = Enum.at(res["pizzas"], 0)
      assert item["pizza_id"] == 2
      assert item["qty"] == 1
      assert res["total"] == 450
    end

    test "POST /cart on an existing cart should update the qty" do
      conn(:post, "/cart", %{pizza_id: 3})
      |> put_req_header("authorization", "Bearer USER_2")
      |> put_req_header("content-type", "application/json")
      |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      conn =
        conn(:post, "/cart", %{pizza_id: 3, qty: 3})
        |> put_req_header("authorization", "Bearer USER_2")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert conn.status == 201
      assert Enum.count(res["pizzas"]) == 1
      item = Enum.at(res["pizzas"], 0)
      assert item["pizza_id"] == 3
      assert item["qty"] == 4
      assert res["total"] == 2800
    end

    test "GET /cart should return your cart" do
      start_supervised!({Server, ["USER_3"]})

      conn =
        conn(:get, "/cart")
        |> put_req_header("authorization", "Bearer USER_3")
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert conn.status == 200
      assert res == %{"pizzas" => [], "total" => 0}
    end
  end
end
