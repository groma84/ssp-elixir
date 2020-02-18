defmodule Lobby do
  def list_open_games() do
    Enum.map(OpenGames.get_all(), fn game_id ->
      game_data = Game.get(game_id)
      %{game_id: game_id, player1_name: game_data.player1.name}
    end)
  end
end
