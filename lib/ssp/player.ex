defmodule Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:player_id, :string)
    field(:name, :string, default: "")
  end

  def changeset(player, params \\ %{}) do
    player
    |> cast(params, [:player_id, :name])
    |> validate_required([:player_id])
    |> validate_length(:name, min: 1, max: 20)
  end
end
