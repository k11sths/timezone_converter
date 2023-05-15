defmodule TimezoneConverter.UserCitiesTest do
  use TimezoneConverter.DataCase

  alias TimezoneConverter.UserCities

  describe "user_cities" do
    alias TimezoneConverter.UserCities.UserCity

    import TimezoneConverter.UserCitiesFixtures

    @invalid_attrs %{city_id: nil, user_id: nil}

    test "list_user_cities/0 returns all user_cities" do
      user_city = user_city_fixture()
      assert UserCities.list_user_cities(1) == [user_city]
    end

    test "get_user_city!/1 returns the user_city with given id" do
      user_city = user_city_fixture()

      assert UserCities.get_user_city!(user_city.id) == user_city
    end

    @tag :k11sths

    test "create_user_city/1 with valid data creates a user_city" do
      changset = UserCities.change_user_city(%UserCity{}, %{city_id: 42, user_id: 1})

      assert {:ok, %UserCity{} = user_city} = UserCities.create_user_city(changset)
      assert user_city.city_id == 42
      assert user_city.user_id == 1
    end

    @tag :k11sths
    test "create_user_city/1 with invalid data returns error changeset" do
      changset = UserCities.change_user_city(%UserCity{}, @invalid_attrs)

      assert {:error, %Ecto.Changeset{}} = UserCities.create_user_city(changset)
    end

    test "update_user_city/2 with valid data updates the user_city" do
      user_city = user_city_fixture()
      update_attrs = %{city_id: 43, user_id: 2}

      assert {:ok, %UserCity{} = user_city} = UserCities.update_user_city(user_city, update_attrs)
      assert user_city.city_id == 43
      assert user_city.user_id == 2
    end

    test "update_user_city/2 with invalid data returns error changeset" do
      user_city = user_city_fixture()
      assert {:error, %Ecto.Changeset{}} = UserCities.update_user_city(user_city, @invalid_attrs)
      assert user_city == UserCities.get_user_city!(user_city.id)
    end

    test "delete_user_city/1 deletes the user_city" do
      user_city = user_city_fixture()
      assert {:ok, %UserCity{}} = UserCities.delete_user_city(user_city)
      assert_raise Ecto.NoResultsError, fn -> UserCities.get_user_city!(user_city.id) end
    end

    test "change_user_city/1 returns a user_city changeset" do
      user_city = user_city_fixture()
      assert %Ecto.Changeset{} = UserCities.change_user_city(user_city)
    end
  end
end
