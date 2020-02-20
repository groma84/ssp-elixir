defmodule Lobby do
  def list_open_games() do
    OpenGames.get_all()
    |> format_games_for_display()
  end

  def format_games_for_display(open_games) do
    Enum.map(open_games, fn game_id ->
      game_data = Game.get(game_id)
      %{game_id: game_id, player1_name: game_data.player1.name}
    end)
  end
end
