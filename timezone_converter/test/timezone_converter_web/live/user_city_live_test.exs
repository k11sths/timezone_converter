defmodule TimezoneConverterWeb.UserCityLiveTest do
  use TimezoneConverterWeb.ConnCase

  import Phoenix.LiveViewTest
  import TimezoneConverter.UserCitiesFixtures
  import TimezoneConverter.AccountsFixtures

  @create_attrs %{city_id: 42, user_id: 42}
  @update_attrs %{city_id: 43, user_id: 43}
  @invalid_attrs %{city_id: nil, user_id: nil}

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

    test "saves new user_city", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/user_cities")

      assert index_live |> element("a", "New User city") |> render_click() =~
               "New User city"

      assert_patch(index_live, ~p"/user_cities/new")

      assert index_live
             |> form("#user_city-form", user_city: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_city-form", user_city: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_cities")

      html = render(index_live)
      assert html =~ "User city created successfully"
    end

    test "deletes user_city in listing", %{conn: conn, user_city: user_city} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/user_cities")

      assert index_live |> element("#user_cities-#{user_city.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_cities-#{user_city.id}")
    end
  end

  describe "Show" do
    setup [:create_user_city]

    test "displays user_city", %{conn: conn, user_city: user_city} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/user_cities/#{user_city}")

      assert html =~ "Show User city"
    end

    test "updates user_city within modal", %{conn: conn, user_city: user_city} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/user_cities/#{user_city}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User city"

      assert_patch(show_live, ~p"/user_cities/#{user_city}/show/edit")

      assert show_live
             |> form("#user_city-form", user_city: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_city-form", user_city: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_cities/#{user_city}")

      html = render(show_live)
      assert html =~ "User city updated successfully"
    end
  end
end
