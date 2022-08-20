defmodule TorTracker.Repo.Migrations.AddBandwidthToInfo do
  use Ecto.Migration

  def change do
    alter table(:info) do
      add :bandwidth_limit, :integer
      add :bandwidth_burst, :integer
    end
  end
end
