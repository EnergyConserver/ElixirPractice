defmodule TaxiBeWeb.TaxiAllocationJob do
  use GenServer

  def start_link(request, name) do
    GenServer.start_link(__MODULE__, request, name: name)
  end

  def init(request) do
    Process.send(self(), :part1, [:nosuspend])
    {:ok,
      %{
        request: request,
        timer: nil,
        accepted_driver: nil,
        accepted_at: nil,
        arrival_time: nil,
        rejections: 0
        }
    }
  end

  def handle_info(:part1,  %{request: request} = state) do
    Process.sleep(1000)

    # Computation of fare
    TaxiBeWeb.Endpoint.broadcast("customer:luciano", "booking_request", %{msg: "Your ride is worth 80 pesitos"})

    taxis = candidate_taxis()

    {selected, timer} = part2(state |> Map.put(:taxis, taxis |> Enum.shuffle))
    {:noreply, state |> Map.put(:contacted_taxis, selected) |> Map.put(:timer, timer)}
  end

  def handle_info(:timeout, state) do

    IO.puts("Boom !!!")
    {:noreply, state}
  end

  def handle_info(:allocation_timeout, state) do
    if state.accepted_driver == nil do
      customer =
        state.request["username"]

      TaxiBeWeb.Endpoint.broadcast(
        "customer:" <> customer,
        "booking_request",
        %{
          msg: "No fue posible asignar un conductor"
        }
      )

      Enum.each(state.contacted_taxis || [], fn taxi ->
        TaxiBeWeb.Endpoint.broadcast(
          "driver:" <> taxi.nickname,
          "booking_cancelled",
          %{
            msg: "Tiempo de espera agotado"
          }
        )
      end)

      {:stop, :normal, state}
    else
      {:noreply, state}
    end
  end

  def part2(state) do
    %{taxis: taxis, request: request} = state

    selected =
      taxis
      |> Enum.take(3)

    # Forward request to taxi driver
    %{
      "pickup_address" => pickup_address,
      "dropoff_address" => dropoff_address,
      "booking_id" => booking_id
    } = request

    Enum.each(selected, fn taxi ->
      TaxiBeWeb.Endpoint.broadcast(
        "driver:" <> taxi.nickname,
        "booking_request",
        %{
          msg: "Viaje de '#{pickup_address}' a '#{dropoff_address}'",
          bookingId: booking_id
        }
      )
    end)
    timer = Process.send_after(self(), :allocation_timeout, 90_000)
    {selected, timer}
  end


  def handle_cast({:accept, username}, state) do
    if state.accepted_driver == nil do
      if state.timer != nil do
        Process.cancel_timer(state.timer)
      end

      Enum.each(state.contacted_taxis, fn taxi ->
        if taxi.nickname != username do
          TaxiBeWeb.Endpoint.broadcast(
            "driver:" <> taxi.nickname,
            "booking_cancelled",
            %{
              msg: "Otro conductor aceptó el viaje"
            }
          )
        end
      end)

      arrival_time =
        DateTime.add(
          DateTime.utc_now(),
          300,
          :second
        )

      customer =
        state.request["username"]

      TaxiBeWeb.Endpoint.broadcast(
        "customer:" <> customer,
        "booking_request",
        %{
          msg: "Taxi #{username} llegará en 5 minutos"
        }
      )

      {:noreply, state
        |> Map.put(:accepted_driver, username)
        |> Map.put(:accepted_at, DateTime.utc_now())
        |> Map.put(:arrival_time, arrival_time)}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:reject, _username}, state) do
    rejections = state.rejections + 1
    if rejections >= length(state.contacted_taxis) do
      customer = state.request["username"]

      TaxiBeWeb.Endpoint.broadcast(
        "customer:" <> customer,
        "booking_request",
        %{
          msg: "No fue posible asignar un conductor"
        }
      )

      Enum.each(state.contacted_taxis || [], fn taxi ->
        TaxiBeWeb.Endpoint.broadcast(
          "driver:" <> taxi.nickname,
          "booking_cancelled",
          %{
            msg: "Todos los conductores rechazaron el viaje"
          }
        )
      end)

      {:stop, :normal, %{state | rejections: rejections}}
    else
      {:noreply, %{state | rejections: rejections}}
    end
  end

  def handle_cast({:cancel, _username}, state) do
    customer =
      state.request["username"]

    cond do
      state.accepted_driver == nil ->
        IO.puts("CASE 1")
        TaxiBeWeb.Endpoint.broadcast(
          "customer:" <> customer,
          "booking_request",
          %{msg: "Trip cancelled. No fee."}
        )

    true ->

      remaining =
        DateTime.diff(
          state.arrival_time,
          DateTime.utc_now(),
          :second
        )

      if remaining <= 180 do
        IO.puts("CASE 3")
        TaxiBeWeb.Endpoint.broadcast(
          "customer:" <> customer,
          "booking_request",
          %{msg: "Trip cancelled. Fee: $20"}
        )

      else
        IO.puts("CASE 2")
        TaxiBeWeb.Endpoint.broadcast(
          "customer:" <> customer,
          "booking_request",
          %{msg: "Trip cancelled. No fee."}
        )

      end
    end

    Enum.each(state.contacted_taxis || [], fn taxi ->
      TaxiBeWeb.Endpoint.broadcast(
        "driver:" <> taxi.nickname,
        "booking_cancelled",
        %{
          msg: "El cliente canceló el viaje"
        }
      )
    end)

    {:stop, :normal, state}
  end

  def compute_ride_fare(request) do
    %{
      "pickup_address" => pickup_address,
      "dropoff_address" => dropoff_address
    } = request

    # coord1 = TaxiBeWeb.Geolocator.geocode(pickup_address)
    # coord2 = TaxiBeWeb.Geolocator.geocode(dropoff_address)
    # {distance, _duration} = TaxiBeWeb.Geolocator.distance_and_duration(coord1, coord2)
    {request, 80.0} # Float.ceil(distance/300)}
  end

  def notify_customer_ride_fare({request, fare}) do
    %{"username" => customer} = request
  TaxiBeWeb.Endpoint.broadcast("customer:" <> customer, "booking_request", %{msg: "Ride fare: #{fare}"})
  end

  def select_candidate_taxis(%{"pickup_address" => _pickup_address}) do
    [
      %{nickname: "angelopolis", latitude: 19.0319783, longitude: -98.2349368},
      %{nickname: "arcangeles", latitude: 19.0061167, longitude: -98.2697737},
      %{nickname: "destino", latitude: 19.0092933, longitude: -98.2473716}
    ]
  end

  def candidate_taxis() do
    [
      %{nickname: "frodo", latitude: 19.0319783, longitude: -98.2349368}, # Angelopolis
      %{nickname: "samwise", latitude: 19.0061167, longitude: -98.2697737}, # Arcangeles
      %{nickname: "pipin", latitude: 19.0092933, longitude: -98.2473716} # Paseo Destino
    ]
  end

  def handle_info(msg, state) do
    IO.puts("UNEXPECTED MESSAGE")
    IO.inspect(msg)

    {:noreply, state}
  end
end
