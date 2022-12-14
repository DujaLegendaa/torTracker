defmodule TorTracker.Relay.Info.Query do
  import Ecto.Query
  alias TorTracker.Relay.Info

  def base, do: Info

  def for_user(user, query \\ base()) do
    query
    |> where([u], u.user_id == ^user.id)
  end

  def only_id(query) do
    query
    |> select([i], i.id)
  end

  def only_fingerprint(query) do
    query
    |> select([i], i.fingerprint)
  end

end
