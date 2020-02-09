defmodule Round do
  use TypedStruct

  typedstruct do
    field(:player1_choice, Move.move())
    field(:player2_choice, Move.move())
  end
end
