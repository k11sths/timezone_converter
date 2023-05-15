defmodule TimezoneConverterWeb.PageController do
  @moduledoc false

  use TimezoneConverterWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: ~p"/user_cities")
  end
end
