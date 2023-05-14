defmodule TimezoneConverter.SupportedCities do
  @moduledoc false

  import Ecto.Query, warn: false
  alias TimezoneConverter.Repo

  alias TimezoneConverter.Cities.SupportedCity, as: SupportedCitySchema

  def get_all_unadded_cities_by_name_like(user_cities, name) do
    Repo.all(
      from(sc in SupportedCitySchema,
        where: like(sc.name, ^"#{name}%") and sc.id not in ^user_cities,
        limit: 20
      )
    )
  end
end
