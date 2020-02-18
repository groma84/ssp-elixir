defmodule SspWeb.GameLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(SspWeb.GameView, "index.html", assigns)
  end

  def mount(
        _params,
        %{"game_id" => game_id, "player_id" => player_id},
        socket
      ) do
    game_data = Game.get(game_id)

    # field(:session_id, :string, enforce: true)
    # field(:player1, Player.t(), enforce: true)
    # field(:player2, Player.t())
    # field(:current_round, Round.t(), default: %Round{})
    # field(:last_round, Round.t())
    # field(:past_decisive_rounds, [Round.t()], default: [])
    # field(:winner, Player.t())

    player_data = get_current_player_data(game_data, player_id)

    {:ok, assign(socket, Map.merge(%{game_id: game_id}, player_data))}
  end

  defp get_current_player_data(game_data, player_id) do
    if game_data.player1.player_id == player_id do
      %{
        my_player_id: game_data.player1.player_id,
        my_player_name: game_data.player1.name,
        other_player_name: get_name_or_empty(game_data.player2)
      }
    else
      %{
        my_player_id: game_data.player2.player_id,
        my_player_name: game_data.player2.name,
        other_player_name: get_name_or_empty(game_data.player1)
      }
    end
  end

  defp get_name_or_empty(player) do
    if is_nil(player) do
      ""
    else
      player.name
    end
  end
end
