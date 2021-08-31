defmodule ZiosPizza.Plug.Auth do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts \\ []) do
    conn
    |> get_req_header("authorization")
    |> Enum.at(0)
    |> handle_user(conn)
  end

  defp handle_user(nil, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, Jason.encode!(%{error: "unauthorized"}))
    |> halt
  end

  defp handle_user("Bearer " <> user, conn) do
    assign(conn, :user, user)
  end
end
