defmodule Round do
  use TypedStruct

  typedstruct do
    field(:player1_choice, Choice.t())
    field(:player2_choice, Choice.t())
  end
end
