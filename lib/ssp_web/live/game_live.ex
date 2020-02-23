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
    game_data =
      Game.get(game_id)
      |> parse_game_data(player_id)

    Phoenix.PubSub.subscribe(Ssp.PubSub, game_id)

    {:ok,
     assign(
       socket,
       Map.merge(game_data, %{my_player_id: player_id})
     )}
  end

  def handle_event(
        "make_move",
        %{"move" => move_string},
        %{assigns: %{game_id: game_id, my_player_id: player_id}} = socket
      ) do
    move =
      case move_string do
        "rock" -> :rock
        "paper" -> :paper
        "scissors" -> :scissors
      end

    new_game_state = Game.update_move(game_id, player_id, move)
    {:noreply, assign(socket, game_state: new_game_state)}
  end

  def handle_event("end_game", %{}, %{assigns: %{game_id: game_id}} = socket) do
    GameSupervisor.end_game(game_id)

    {:noreply,
     socket
     |> redirect(to: SspWeb.Router.Helpers.lobby_path(SspWeb.Endpoint, :index))}
  end

  def handle_info(
        {:update_game_state, game_state},
        %{assigns: %{my_player_id: player_id}} = socket
      ) do
    {:noreply, assign(socket, parse_game_data(game_state, player_id))}
  end

  defp parse_game_data(game_data, player_id) do
    player_data = get_current_player_data(game_data, player_id)

    Map.merge(
      %{
        game_id: game_data.game_id,
        someone_has_won: !is_nil(game_data.winner),
        last_round: format_last_round(game_data, player_id),
        score: Play.calculate_score(game_data, player_id)
      },
      player_data
    )
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

  defp format_last_round(game_data, player_id) do
    if is_nil(game_data.last_round) do
      nil
    else
      if game_data.player1.player_id == player_id do
        %{
          my_last_move: move_to_string(game_data.last_round.player1_choice),
          other_last_move: move_to_string(game_data.last_round.player2_choice)
        }
      else
        %{
          my_last_move: move_to_string(game_data.last_round.player2_choice),
          other_last_move: move_to_string(game_data.last_round.player1_choice)
        }
      end
    end
  end

  defp move_to_string(move) do
    case move do
      :rock -> "Stein"
      :paper -> "Papier"
      :scissors -> "Schere"
    end
  end
end
