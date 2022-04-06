defmodule ZiosPizza.Cart.RouterTest do
  use ExUnit.Case
  use Plug.Test
  use ZiosPizza.RepoCase

  describe "Cart router" do
    test "POST /cart should create a new cart" do
      conn =
        conn(:post, "/cart", %{pizza_id: 2})
        |> put_req_header("content-type", "application/json")
        |> ZiosPizza.Router.call(ZiosPizza.Router.init([]))

      res = Jason.decode!(conn.resp_body)

      assert conn.status == 201

      pizza = Enum.at(res["pizzas"], 0)
      assert pizza["id"] == 2
    end
  end
end
