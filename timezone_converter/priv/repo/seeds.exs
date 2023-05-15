alias TimezoneConverter.Cities

"./priv/supported_cities.csv"
|> Path.expand()
|> File.stream!()
|> CSV.decode!(
  separator: ?;,
  headers: [:country_code, :country_name, :name, :gmt_offset, :timezone],
  field_transform: &String.trim/1
)
|> Enum.each(fn %{gmt_offset: gmt_offset} = city ->
  Cities.create!(%{city | gmt_offset: String.to_integer(gmt_offset)})
end)

if Mix.env() == :test do
  TimezoneConverter.Accounts.register_user(%{
    "email" => "this@test1.com",
    "password" => "number654321"
  })

  TimezoneConverter.Accounts.register_user(%{
    "email" => "this@test2.com",
    "password" => "number123456"
  })
end
