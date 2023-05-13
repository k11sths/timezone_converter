defmodule TimezoneConverter.Repo.Migrations.CreateUserCities do
  use Ecto.Migration

  def change do
    create table(:user_cities) do
      add :user_id, :integer
      add :city_id, :integer

      timestamps()
    end
  end
end
