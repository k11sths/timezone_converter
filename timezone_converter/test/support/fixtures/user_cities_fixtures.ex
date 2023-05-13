defmodule TimezoneConverter.UserCitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimezoneConverter.UserCities` context.
  """

  @doc """
  Generate a user_city.
  """
  def user_city_fixture(attrs \\ %{}) do
    {:ok, user_city} =
      attrs
      |> Enum.into(%{
        city_id: 42,
        user_id: 42
      })
      |> TimezoneConverter.UserCities.create_user_city()

    user_city
  end
end
