defmodule ZiosPizza.Carts.CommandBuilderTest do
  use ExUnit.Case
  use ZiosPizza.RepoCase
  alias ZiosPizza.Carts.CommandBuilder

  describe "Command builder" do
    test "build_add_pizza_cmd with a valid payload" do
      {:ok, result} = CommandBuilder.build_add_pizza_cmd(%{"pizza_id" => 2})
      assert {:add_pizza, %{pizza_id: 2, qty: 1, name: "Marinara", price: 450}} == result
    end

    test "build_add_pizza_cmd specify quantity" do
      {:ok, result} = CommandBuilder.build_add_pizza_cmd(%{"pizza_id" => 3, "qty" => 2})
      assert {:add_pizza, %{pizza_id: 3, qty: 2, name: "Verdure", price: 700}} == result
    end

    test "build_add_pizza_cmd missing pizza_id, should return errors" do
      {:error, result} = CommandBuilder.build_add_pizza_cmd(%{"qty" => 2})
      assert ["Required property pizza_id was not present."] == result
    end
  end
end
