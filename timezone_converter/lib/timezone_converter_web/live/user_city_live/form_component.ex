defmodule TimezoneConverterWeb.UserCityLive.FormComponent do
  use TimezoneConverterWeb, :live_component

  alias TimezoneConverter.UserCities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage user_city records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_city-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:city_id]} type="text" label="City Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save User city</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_city: user_city} = assigns, socket) do
    changeset = UserCities.change_user_city(user_city)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_city" => user_city_params}, socket) do
    changeset =
      socket.assigns.user_city
      |> UserCities.change_user_city(user_city_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user_city" => user_city_params}, socket) do
    save_user_city(socket, socket.assigns.action, user_city_params)
  end

  defp save_user_city(socket, :new, user_city_params) do
    create_result =
      socket.assigns.user_city
      |> UserCities.change_user_city(user_city_params)
      |> UserCities.create_user_city()

    case create_result do
      {:ok, user_city} ->
        notify_parent({:saved, user_city})

        {:noreply,
         socket
         |> put_flash(:info, "User city created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
