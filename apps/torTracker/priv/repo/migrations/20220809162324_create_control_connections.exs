defmodule TorTracker.Repo.Migrations.CreateControlConnections do
  use Ecto.Migration

  def change do
    create table(:control_connections) do
      add :name, :string
      add :ip, :string
      add :port, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:control_connections, [:user_id])
  end
end
