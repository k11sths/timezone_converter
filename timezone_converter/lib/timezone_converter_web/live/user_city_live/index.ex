defmodule TimezoneConverterWeb.UserCityLive.Index do
  use TimezoneConverterWeb, :live_view

  on_mount {TimezoneConverterWeb.UserAuth, :mount_current_user}

  alias TimezoneConverter.UserCities
  alias TimezoneConverter.UserCities.UserCity

  @impl true
  def mount(_params, _session, socket) do
    %{assigns: %{current_user: %{id: user_id}}} = socket
    user_cities = UserCities.list_user_cities(user_id)
    socket = assign(socket, :user_cities, user_cities)

    {:ok, socket}
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

  def handle_event("save", %{"id" => supported_city_id}, socket) do
    %{assigns: %{current_user: %{id: user_id}}} = socket

    create_result =
      %UserCity{}
      |> UserCities.change_user_city(%{user_id: user_id, city_id: supported_city_id})
      |> UserCities.create_user_city()

    case create_result do
      {:ok, user_city} ->
        {:noreply,
         socket
         |> put_flash(:info, "User city added successfully")
         |> assign(:user_cities, [user_city | socket.assigns.user_cities])}

      {:error, _} ->
        {:noreply, put_flash(socket, :info, "Failed to add user city")}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_city = UserCities.get_user_city!(id)
    {:ok, user_city} = UserCities.delete_user_city(user_city)

    updated_user_cities =
      Enum.reject(socket.assigns.user_cities, fn %{id: id} -> user_city.id == id end)

    {:noreply, assign(socket, :user_cities, updated_user_cities)}
  end
end
