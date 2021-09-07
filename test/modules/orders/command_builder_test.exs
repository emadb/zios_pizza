defmodule ZiosPizza.Orders.CommandBuilderTest do
  use ExUnit.Case
  use ZiosPizza.RepoCase
  import Mock
  alias ZiosPizza.Orders.CommandBuilder

  describe "Command builder" do
    test "build_create_order_cmd with a valid payload" do
      with_mock(ZiosPizza.Carts.Gateway,
        execute: fn "USER_1", :get_state -> {:ok, %ZiosPizza.Carts.Cart{}} end
      ) do
        {:ok, result} =
          CommandBuilder.build_create_order_cmd("USER_1", %{"payment_token" => "ABC"})

        assert result ==
                 {:create_order,
                  %{user_id: "USER_1", payment_token: "ABC", cart: %ZiosPizza.Carts.Cart{}}}
      end
    end

    test "build_create_order_cmd without token" do
      {:error, _} = CommandBuilder.build_create_order_cmd("USER_1", %{})
    end
  end
end
