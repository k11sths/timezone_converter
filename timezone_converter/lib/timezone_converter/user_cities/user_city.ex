defmodule TimezoneConverter.UserCities.UserCity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_cities" do
    field :city_id, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user_city, attrs) do
    user_city
    |> cast(attrs, [:user_id, :city_id])
    |> validate_required([:user_id, :city_id])
  end
end
