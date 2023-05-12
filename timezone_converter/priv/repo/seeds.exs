alias TimezoneConverter.Cities

"./priv/supported_cities.csv"
|> Path.expand()
|> File.stream!()
|> CSV.decode!(
  separator: ?;,
  headers: [:country_code, :country_name, :name, :gmt_offset],
  field_transform: &String.trim/1
)
|> Enum.each(fn %{gmt_offset: gmt_offset} = city ->
  Cities.create!(%{city | gmt_offset: String.to_integer(gmt_offset)})
end)
