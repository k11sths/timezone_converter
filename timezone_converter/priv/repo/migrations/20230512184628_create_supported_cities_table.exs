defmodule TimezoneConverter.Repo.Migrations.CreateSupportedCitiesTable do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS citext", "")

    create table(:supported_cities) do
      add(:country_code, :string, null: false)
      add(:country_name, :string, null: false)
      add(:timezone, :string, null: false)
      add(:name, :string, null: false)
      add(:gmt_offset, :integer, default: 0)
      timestamps()
    end

    create(index(:supported_cities, [:name]))
  end
end
