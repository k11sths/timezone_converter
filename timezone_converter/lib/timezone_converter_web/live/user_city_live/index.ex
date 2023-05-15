defmodule TimezoneConverterWeb.UserCityLive.Index do
  use TimezoneConverterWeb, :live_view

  on_mount {TimezoneConverterWeb.UserAuth, :mount_current_user}

  alias TimezoneConverter.UserCities
  alias TimezoneConverter.UserCities.UserCity

  @impl true
  def mount(_params, _session, socket) do
    %{assigns: %{current_user: %{id: user_id}}} = socket
    timezone = get_connect_params(socket)["timezone"] || "Europe/Athens"
    users_time = DateTime.now!(timezone)
    offset = get_offset(users_time, timezone)
    user_cities = user_id |> UserCities.list_user_cities() |> set_current_time(offset)
    user_cities_ids = Enum.map(user_cities, fn %{city_id: city_id} -> city_id end)
    if connected?(socket), do: Process.send_after(self(), :tick, 1_000)

    {:ok,
     socket
     |> assign(:user_cities, user_cities)
     |> assign(:user_cities_ids, user_cities_ids)
     |> assign(:timezone, timezone)
     |> assign(:offset, offset)
     |> assign(:live_clock, true)
     |> assign(:users_time, users_time), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User city")
    |> assign(:user_city, %UserCity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User cities")
    |> assign(:user_city, nil)
  end

  @impl true
  def handle_event("reset_current_time", _, socket) do
    %{assigns: %{user_cities: user_cities, timezone: timezone}} = socket
    users_time = DateTime.now!(timezone)
    offset = get_offset(users_time, timezone)
    user_cities = set_current_time(user_cities, offset)
    if connected?(socket), do: Process.send_after(self(), :tick, 1_000)

    {:noreply,
     socket
     |> assign(:user_cities, user_cities)
     |> assign(:offset, offset)
     |> assign(:users_time, users_time)
     |> assign(:live_clock, true)}
  end

  def handle_event("set_current_time", %{"users_time" => users_time}, socket) do
    %{assigns: %{user_cities: user_cities, timezone: timezone}} = socket
    users_time = parse_users_time_input(users_time, timezone)

    offset = get_offset(users_time, timezone)

    user_cities = set_current_time(user_cities, offset)

    {:noreply,
     socket
     |> assign(:user_cities, user_cities)
     |> assign(:offset, offset)
     |> assign(:users_time, users_time)
     |> assign(:live_clock, false)}
  end

  @impl true
  def handle_event("save", %{"id" => supported_city_id}, socket) do
    %{
      assigns: %{
        user_cities_ids: user_cities_ids,
        user_cities: user_cities,
        timezone: timezone,
        offset: offset,
        current_user: %{id: user_id}
      }
    } = socket

    create_result =
      %UserCity{}
      |> UserCities.change_user_city(%{user_id: user_id, city_id: supported_city_id})
      |> UserCities.create_user_city()

    case create_result do
      {:ok, %{id: id, supported_city: %{gmt_offset: gmt_offset}} = user_city} ->
        time_now = get_datetime_now(timezone) |> DateTime.add(gmt_offset + offset, :minute)
        user_city = Map.put(user_city, :time_now, time_now)

        {:noreply,
         socket
         |> put_flash(:info, "User city added successfully")
         |> assign(:user_cities, [user_city | user_cities])
         |> assign(:user_cities_ids, [id | user_cities_ids])}

      {:error, _} ->
        {:noreply, put_flash(socket, :info, "Failed to add user city")}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    %{assigns: %{user_cities: user_cities}} = socket
    user_city = UserCities.get_user_city!(id)
    {:ok, user_city} = UserCities.delete_user_city(user_city)
    updated_user_cities = Enum.reject(user_cities, fn %{id: id} -> user_city.id == id end)

    {:noreply, assign(socket, :user_cities, updated_user_cities)}
  end

  @impl true
  def handle_info(:tick, %{assigns: %{live_clock: false}} = socket), do: {:noreply, socket}

  def handle_info(:tick, socket) do
    %{
      assigns: %{
        user_cities: user_cities,
        offset: offset,
        timezone: timezone
      }
    } = socket

    updated_user_cities = set_current_time(user_cities, offset)
    users_time = timezone |> DateTime.now!() |> DateTime.add(offset, :minute)
    Process.send_after(self(), :tick, 1_000)

    {:noreply,
     socket
     |> assign(:user_cities, updated_user_cities)
     |> assign(:users_time, users_time)}
  end

  defp set_current_time(user_cities, offset) do
    Enum.map(user_cities, fn %{supported_city: %{gmt_offset: gmt_offset}} = user_city ->
      time_now =
        DateTime.utc_now()
        |> DateTime.add(gmt_offset + offset, :minute)

      Map.put(user_city, :time_now, time_now)
    end)
  end

  defp parse_users_time_input(users_time, timezone) do
    [hours, minutes] = String.split(users_time, ":")
    now = get_datetime_now(timezone)

    %{
      now
      | hour: String.to_integer(hours),
        minute: String.to_integer(minutes),
        time_zone: timezone
    }
  end

  defp get_datetime_now(timezone), do: DateTime.now!(timezone) |> DateTime.truncate(:second)

  defp get_offset(users_time, timezone),
    do: DateTime.diff(users_time, DateTime.now!(timezone), :minute)
end
