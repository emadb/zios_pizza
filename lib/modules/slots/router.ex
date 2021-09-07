defmodule ZiosPizza.Slots.Router do
  use Plug.Router
  alias ZiosPizza.Slots.CommandBuilder
  alias ZiosPizza.Slots.Gateway
  alias ZiosPizza.Slots.Repo

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(ZiosPizza.Plug.Auth)
  plug(:match)
  plug(:dispatch)

  get "/" do
    from = Date.from_iso8601!(conn.query_params["from"])
    to = Date.from_iso8601!(conn.query_params["to"])

    slots = Repo.get_by_date_range(from, to)

    res = Enum.map(slots, &project_slot/1)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(res))
  end

  get "/:date" do
    slots = Repo.get_by_date(Date.from_iso8601!(date))
    res = Enum.map(slots, &project_slot/1)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(res))
  end

  post "/:datetime" do
    user = conn.assigns[:user]
    {:ok, cmd} = CommandBuilder.build_reserve_slot_command(user)
    {:ok, datetime, _} = DateTime.from_iso8601(datetime)

    case Gateway.execute(datetime, cmd) do
      {:ok, slot} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(201, Jason.encode!(project_slot(slot)))

      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{message: message}))
    end
  end

  defp project_slot(slot) do
    %{
      datetime: slot.datetime,
      status: get_status(slot.capacity, slot.reserved)
    }
  end

  defp get_status(0, _) do
    :disabled
  end

  defp get_status(capacity, reserved) when capacity > reserved do
    :available
  end

  defp get_status(_, _) do
    :not_available
  end
end
