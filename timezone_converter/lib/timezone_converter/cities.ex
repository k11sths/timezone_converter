defmodule TimezoneConverter.Cities do
  @moduledoc """
  The Cities context.
  """

  import Ecto.Query, warn: false

  alias TimezoneConverter.Repo
  alias TimezoneConverter.Cities.SupportedCity

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create!(attrs) do
    %SupportedCity{}
    |> SupportedCity.changeset(attrs)
    |> Repo.insert!()
  end
end
