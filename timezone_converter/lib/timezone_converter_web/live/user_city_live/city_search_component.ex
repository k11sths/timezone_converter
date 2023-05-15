defmodule TimezoneConverterWeb.UserCityLive.CitySearchComponent do
  use TimezoneConverterWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.search_modal :if={@show} id="search-modal" show on_cancel={@on_cancel}>
        <.search_input
          value={@query}
          phx-target={@myself}
          phx-keyup="do-search"
          phx-focus="do-search"
          phx-debounce="200"
        />
        <.search_results cities={@cities} />
      </.search_modal>
    </div>
    """
  end

  @impl true
  def handle_event("do-search", %{"value" => name}, socket) do
    %{assigns: %{user_cities_ids: user_cities_ids}} = socket

    {:noreply,
     socket
     |> assign(:search, name)
     |> assign(
       :cities,
       TimezoneConverter.SupportedCities.get_all_unadded_cities_by_name_like(
         user_cities_ids,
         name
       )
     )}
  end
end
