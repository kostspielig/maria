defmodule Maria.Drinking do
  @moduledoc """
  The Drinking context.
  """

  import Ecto.Query, warn: false
  alias Maria.Repo

  alias Maria.Drinking.Wine

  @doc """
  Returns the list of wines.

  ## Examples

      iex> list_wines()
      [%Wine{}, ...]

  """
  def list_wines(draft \\ false) do

    query = if draft do
      from w in Wine,
        where: is_nil(w.is_draft) or w.is_draft == false,
        order_by: [desc: coalesce(w.updated_at, w.inserted_at)]
    else
        from w in Wine,
          order_by: [desc: coalesce(w.updated_at, w.inserted_at)]
    end

    query
    |> Repo.all()
    |> Repo.preload(:user)
    |> Repo.preload(:editor)
  end

  @doc """
  Gets a single wine.

  Raises `Ecto.NoResultsError` if the Wine does not exist.

  ## Examples

      iex> get_wine!(123)
      %Wine{}

      iex> get_wine!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wine!(id), do: Repo.get!(Wine, id) |> Repo.preload(:user)  |> Repo.preload(:editor)

  @doc """
  Returns the list of wines by its author.

  ## Examples

      iex> list_wines( %User{id: 1})
      [%Wine{}, ...]

  """
  def list_wines_by(user) do
    Wine |> where(user_id: ^user.id) |> order_by([w], desc: coalesce(w.updated_at, w.inserted_at)) |> Repo.all() |> Repo.preload(:user) |> Repo.preload(:editor)
  end

  @doc """
  Creates a wine.

  ## Examples

      iex> create_wine(%{field: value})
      {:ok, %Wine{}}

      iex> create_wine(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wine(attrs \\ %{}) do
    %Wine{}
    |> Wine.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wine.

  ## Examples

      iex> update_wine(wine, %{field: new_value})
      {:ok, %Wine{}}

      iex> update_wine(wine, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wine(%Wine{} = wine, attrs) do
    wine
    |> Wine.changeset_update(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a wine.

  ## Examples

      iex> delete_wine(wine)
      {:ok, %Wine{}}

      iex> delete_wine(wine)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wine(%Wine{} = wine) do
    Repo.delete(wine)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wine changes.

  ## Examples

      iex> change_wine(wine)
      %Ecto.Changeset{data: %Wine{}}

  """
  def change_wine(%Wine{} = wine, attrs \\ %{}) do
    Wine.changeset(wine, attrs)
  end
end
