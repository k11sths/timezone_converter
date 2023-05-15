defmodule TimezoneConverter.Repo.Migrations.UpdateFieldCityNameToCaseInsensitive do
  use Ecto.Migration

  def change do
    alter table(:supported_cities) do
      modify(:name, :citext, null: false)
    end
  end
end
