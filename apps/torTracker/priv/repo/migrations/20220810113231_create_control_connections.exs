defmodule TorTracker.Repo.Migrations.CreateControlConnections do
  use Ecto.Migration

  def change do
    drop table(:control_connections)

    create table(:control_connections) do
      add :name, :string
      add :ip, :string
      add :port, :integer
      add :info_id, references(:info, on_delete: :nothing)

      timestamps()
    end


    create unique_index(:control_connections, [:info_id])
  end
end
