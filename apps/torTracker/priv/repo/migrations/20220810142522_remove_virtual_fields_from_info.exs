defmodule TorTracker.Repo.Migrations.RemoveVirtualremovesFromInfo do
  use Ecto.Migration

  def change do
    alter table(:info) do
      remove :bandwidth_burst
      remove :bandwidth_limit
      remove :cpu_usage
      remove :ram_usage
      remove :uptime_sec
    end
  end
end
