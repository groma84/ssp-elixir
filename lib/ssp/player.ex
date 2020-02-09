defmodule Player do
  use TypedStruct

  typedstruct do
    field(:player_id, :string, enforce: true)
    field(:name, :string)
  end
end
