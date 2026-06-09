defmodule TaxiBeWeb.BookingController do
  use TaxiBeWeb, :controller
  alias TaxiBeWeb.TaxiAllocationJob
  def create(conn, req) do
    IO.inspect(req)
    booking_id = UUID.uuid1()
    {:ok, pid} =
      GenServer.start(
        TaxiBeWeb.TaxiAllocationJob,
        req |> Map.put("booking_id", booking_id),
        name: String.to_atom(booking_id)
      )
    IO.inspect(pid, label: "BOOKING PID")
    conn
    |> put_resp_header("Location", "/api/bookings/" <> booking_id)
    |> put_status(:created)
    |> json(%{
      msg: "We are processing your request",
      booking_id: booking_id
    })
  end
  def update(conn, %{"action" => "accept", "username" => username, "id" => id}) do
    GenServer.cast(String.to_atom(id), {:accept, username})
    json(conn, %{
      msg: "We will process your acceptance"
    })
  end
  def update(conn, %{"action" => "reject", "username" => username, "id" => id}) do
    GenServer.cast(String.to_atom(id), {:reject, username})
    json(conn, %{msg: "We will process your rejection"})
  end
  def update(conn, %{"action" => "cancel", "username" => username, "id" => id}) do
    IO.puts("CONTROLLER CANCEL")
    IO.puts("ID: #{id}")

    IO.inspect(
      Process.whereis(String.to_atom(id)),
      label: "PROCESS"
    )

    GenServer.cast(String.to_atom(id), {:cancel, username})
    json(conn, %{msg: "We will process your cancelation"})
  end
end
