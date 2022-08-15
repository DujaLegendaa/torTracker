defmodule TorTracker.Relay.Info do
  use Ecto.Schema
  import Ecto.Changeset

  schema "info" do
    field :fingerprint,     :string
    field :flags,           {:array, :string}
    field :name,            :string
    field :ip,              :string,                  default: "0.0.0.0"
    field :port,            :integer,                 default: 9051

    field :bandwidth_burst, :float,   virtual: true,  default: 0.0
    field :bandwidth_limit, :float,   virtual: true,  default: 0.0
    field :cpu_usage,       :float,   virtual: true,  default: 0.0
    field :ram_usage,       :integer, virtual: true,  default: 0
    field :uptime_sec,      :integer, virtual: true,  default: 0

    belongs_to :user, TorTracker.Accounts.User

    timestamps()
  end

  def ip_to_tuple(ip) do
    ip
    |> String.split(".")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  defp validate_positive(changeset, field) do
    validate_number(changeset, field, greater_than_or_equal_to: 0)
  end

  defp validate_ip_and_port(changeset) do
    changeset
    |> validate_format(:ip, ~r/^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/)
    |> validate_inclusion(:port, 0..65_535)
  end

  @doc false
  def changeset(info, attrs) do
    info
    |> cast(attrs, [:fingerprint, :ip, :port])
    |> validate_required([:fingerprint, :ip, :port])
    |> validate_ip_and_port()
    |> unique_constraint(:fingerprint)
  end

  def update_realtime_info_changeset(info, attrs) do
    info
    |> cast(attrs, [:cpu_usage, :ram_usage, :uptime_sec])
    |> validate_positive(:cpu_usage)
    |> validate_positive(:ram_usage)
    |> validate_positive(:uptime_sec)
  end

  def update_changeset(info, attrs) do
    info
    |> cast(attrs, [:fingerprint, :name, :bandwidth_limit, :bandwidth_burst, :ip, :port])
    |> unique_constraint(:fingerprint)
    |> validate_positive(:bandwidth_limit)
    |> validate_number(:bandwidth_limit, less_than: attrs[:bandwidth_limit])
    |> validate_positive(:bandwidth_limit)
    |> validate_ip_and_port()
    
  end
end
