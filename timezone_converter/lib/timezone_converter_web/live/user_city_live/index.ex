defmodule TimezoneConverterWeb.UserCityLive.Index do
  use TimezoneConverterWeb, :live_view

  alias TimezoneConverter.UserCities
  alias TimezoneConverter.UserCities.UserCity

  @impl true
  def mount(_params, _session, socket) do
    user_cities = UserCities.list_user_cities()

    socket = assign(socket, :user_cities, user_cities)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User city")
    |> assign(:user_city, UserCities.get_user_city!(id))
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
  def handle_info({TimezoneConverterWeb.UserCityLive.FormComponent, {:saved, user_city}}, socket) do
    {:noreply, assign(socket, :user_cities, [user_city | socket.assigns.user_cities])}
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