defmodule TorTracker.Relay do
  @moduledoc """
  The Relay context.
  """

  import Ecto.Query, warn: false
  alias TorTracker.Repo

  alias TorTracker.Relay.Info
  alias TorTracker.Accounts.User

  def get_info_ids_by_user(%User{} = user) do
    user
    |> Info.Query.for_user()
    |> Info.Query.only_id() 
    |> Repo.all()

  end

  def get_info_fingerprints_by_user(%User{} = user) do
    user
    |> Info.Query.for_user()
    |> Info.Query.only_fingerprint() 
    |> Repo.all()
    
  end
  @doc """
  Returns the list of info.

  ## Examples

      iex> list_info()
      [%Info{}, ...]

  """
  def list_info() do
    Repo.all(Info)
  end
  def list_info_by_user(%User{} = user) do
    user
    |> Info.Query.for_user()
    |> Repo.all()
  end

  @doc """
  Gets a single info.

  Raises `Ecto.NoResultsError` if the Info does not exist.

  ## Examples

      iex> get_info!(123)
      %Info{}

      iex> get_info!(456)
      ** (Ecto.NoResultsError)

  """
  def get_info_by_fingerprint(fingerprint) do
    Repo.get_by(Info, fingerprint: fingerprint) 
  end
  def get_info!(id), do: Repo.get!(Info, id)

  @doc """
  Creates a info.

  ## Examples

      iex> create_info(%{field: value})
      {:ok, %Info{}}

      iex> create_info(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_info(%User{} = user, attrs \\ %{}) do
    %Info{}
    |> Info.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a info.

  ## Examples

      iex> update_info(info, %{field: new_value})
      {:ok, %Info{}}

      iex> update_info(info, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_realtime_info(%Info{} = info, attrs) do
    info
    |> Info.update_realtime_info_changeset(attrs)
    |> Repo.update()
  end

  def update_info(%Info{} = info, attrs) do
    info
    |> Info.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a info.

  ## Examples

      iex> delete_info(info)
      {:ok, %Info{}}

      iex> delete_info(info)
      {:error, %Ecto.Changeset{}}

  """
  def delete_info(%Info{} = info) do
    Repo.delete(info)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking info changes.

  ## Examples

      iex> change_info(info)
      %Ecto.Changeset{data: %Info{}}

  """
  def change_info(%Info{} = info, attrs \\ %{}) do
    Info.changeset(info, attrs)
  end
end
