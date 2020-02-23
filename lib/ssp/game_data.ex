defmodule GameData do
  use TypedStruct

  typedstruct do
    field(:game_id, String.t(), enforce: true)
    field(:player1, Player.t(), enforce: true)
    field(:player2, Player.t())
    field(:current_round, Round.t(), default: %Round{})
    field(:last_round, Round.t())
    field(:past_decisive_rounds, [Round.t()], default: [])
    field(:winner, Player.t())
    field(:timed_out, boolean(), default: false)
  end
end
