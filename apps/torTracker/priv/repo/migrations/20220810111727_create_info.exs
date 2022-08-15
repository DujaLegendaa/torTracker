defmodule TorTracker.Repo.Migrations.CreateInfo do
  use Ecto.Migration

  def change do
    create table(:info) do
      add :fingerprint, :string
      add :name, :string
      add :bandwidth_limit, :float
      add :bandwidth_burst, :float
      add :flags, {:array, :string}
      add :ip, :string
      add :port, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:info, [:fingerprint])
    create index(:info, [:user_id])
  end
end
