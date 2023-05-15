defmodule TimezoneConverterWeb.UserCityLiveTest do
  use TimezoneConverterWeb.ConnCase

  import Phoenix.LiveViewTest
  import TimezoneConverter.UserCitiesFixtures
  import TimezoneConverter.AccountsFixtures

  defp create_user_city(_) do
    user_city = user_city_fixture()
    %{user_city: user_city}
  end

  describe "Index" do
    setup [:create_user_city]

    test "lists all user_cities", %{conn: conn} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/user_cities")

      assert html =~ "Listing User cities"
    end
  end
end
