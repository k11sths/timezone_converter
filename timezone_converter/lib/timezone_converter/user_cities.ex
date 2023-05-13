defmodule TimezoneConverter.UserCities do
  @moduledoc """
  The UserCities context.
  """

  import Ecto.Query, warn: false
  alias TimezoneConverter.Repo

  alias TimezoneConverter.UserCities.UserCity

  @doc """
  Returns the list of user_cities.

  ## Examples

      iex> list_user_cities()
      [%UserCity{}, ...]

  """
  def list_user_cities(user_id) do
    UserCity |> where(user_id: ^user_id) |> order_by(desc: :id) |> Repo.all()
  end

  @doc """
  Gets a single user_city.

  Raises `Ecto.NoResultsError` if the User city does not exist.

  ## Examples

      iex> get_user_city!(123)
      %UserCity{}

      iex> get_user_city!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_city(id), do: Repo.get(UserCity, id)
  def get_user_city!(id), do: Repo.get!(UserCity, id)

  @doc """
  Creates a user_city.

  ## Examples

      iex> create_user_city(%{field: value})
      {:ok, %UserCity{}}

      iex> create_user_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_city(changeset) do
    Repo.insert(changeset)
  end

  @doc """
  Updates a user_city.

  ## Examples

      iex> update_user_city(user_city, %{field: new_value})
      {:ok, %UserCity{}}

      iex> update_user_city(user_city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_city(%UserCity{} = user_city, attrs) do
    user_city
    |> UserCity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_city.

  ## Examples

      iex> delete_user_city(user_city)
      {:ok, %UserCity{}}

      iex> delete_user_city(user_city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_city(%UserCity{} = user_city) do
    Repo.delete(user_city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_city changes.

  ## Examples

      iex> change_user_city(user_city)
      %Ecto.Changeset{data: %UserCity{}}

  """
  def change_user_city(%UserCity{} = user_city, attrs \\ %{}) do
    UserCity.changeset(user_city, attrs)
  end
end
