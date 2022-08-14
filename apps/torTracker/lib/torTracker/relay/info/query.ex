defmodule TorTracker.Relay.Info.Query do
  import Ecto.Query
  alias TorTracker.Relay.Info

  def base, do: Info

  def for_user(user, query \\ base()) do
    query
    |> where([d], d.user_id == ^user.id)
  end
end
