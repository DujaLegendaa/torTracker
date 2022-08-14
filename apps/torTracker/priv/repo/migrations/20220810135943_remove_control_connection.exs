defmodule TorTracker.Repo.Migrations.RemoveControlConnection do
  use Ecto.Migration

  def change do
    drop table(:control_connections)

    alter table(:info) do
      add :ip, :string 
      add :port, :integer
    end
  end
end
