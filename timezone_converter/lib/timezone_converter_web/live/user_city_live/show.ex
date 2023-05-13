defmodule TimezoneConverterWeb.UserCityLive.Show do
  use TimezoneConverterWeb, :live_view

  alias TimezoneConverter.UserCities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_city, UserCities.get_user_city!(id))}
  end

  defp page_title(:show), do: "Show User city"
  defp page_title(:edit), do: "Edit User city"
end
