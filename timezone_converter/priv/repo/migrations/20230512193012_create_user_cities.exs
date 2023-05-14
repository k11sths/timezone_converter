defmodule TimezoneConverter.Repo.Migrations.CreateUserCities do
  use Ecto.Migration

  def change do
    create table(:user_cities) do
      add :user_id, references(:users)
      add :city_id, references(:supported_cities)

      timestamps()
    end
  end
end
