defmodule TorTracker.Repo do
  use Ecto.Repo,
    otp_app: :torTracker,
    adapter: Ecto.Adapters.Postgres
end
