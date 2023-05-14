defmodule TimezoneConverter.UserCities.UserCity do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "user_cities" do
    belongs_to :user, TimezoneConverter.Accounts.User, foreign_key: :user_id
    belongs_to :supported_city, TimezoneConverter.Cities.SupportedCity, foreign_key: :city_id

    timestamps()
  end

  @doc false
  def changeset(user_city, attrs) do
    user_city
    |> cast(attrs, [:user_id, :city_id])
    |> validate_required([:user_id, :city_id])
  end
end
