defmodule TimezoneConverter.Cities.SupportedCity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "supported_cities" do
    field(:country_code, :string)
    field(:country_name, :string)
    field(:name, :string)
    field(:gmt_offset, :integer, default: 0)

    timestamps()
  end

  def changeset(supported_city, attrs),
    do: cast(supported_city, attrs, [:country_code, :country_name, :name, :gmt_offset])
end
