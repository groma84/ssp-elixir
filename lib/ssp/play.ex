defmodule Play do
  def play(game_state, current_round, playing_player_id, move) do
    cond do
      moves_already_made?(current_round) ->
        {:moves_already_made, game_state}

      somebody_has_won?(game_state) ->
        {:game_already_won, game_state}

      true ->
        move_added =
          case get_player(playing_player_id, game_state) do
            :player1 -> %{current_round | player1_choice: move}
            :player2 -> %{current_round | player2_choice: move}
          end

        if moves_already_made?(move_added) do
          updated_rounds = update_rounds(game_state, move_added)

          case check_for_winner(updated_rounds.past_decisive_rounds) do
            :none -> {:continue_playing, updated_rounds}
            :player1 -> {:game_over, %{updated_rounds | winner: game_state.player1}}
            :player2 -> {:game_over, %{updated_rounds | winner: game_state.player2}}
          end
        else
          {:waiting_for_other_player, %{game_state | current_round: move_added}}
        end
    end
  end

  def calculate_score(state, player_id) do
    current_player = get_player(player_id, state)

    Enum.reduce(state.past_decisive_rounds, %{own_wins: 0, other_wins: 0}, fn round, acc ->
      round_winner = evaluate_round(round.player1_choice, round.player2_choice)

      if round_winner == current_player do
        %{
          own_wins: acc.own_wins + 1,
          other_wins: acc.other_wins
        }
      else
        %{
          own_wins: acc.own_wins,
          other_wins: acc.other_wins + 1
        }
      end
    end)
  end

  @spec moves_already_made?(Round.t()) :: boolean()
  defp moves_already_made?(round) do
    !(is_nil(round.player1_choice) || is_nil(round.player2_choice))
  end

  defp somebody_has_won?(game_state) do
    !is_nil(game_state.winner)
  end

  defp get_player(playing_player_id, state) do
    if playing_player_id == state.player1.player_id do
      :player1
    else
      :player2
    end
  end

  defp is_draw?(round) do
    round.player1_choice == round.player2_choice
  end

  defp update_rounds(old_state, round_move_added) do
    changed_state = %{old_state | current_round: %Round{}, last_round: round_move_added}

    if is_draw?(round_move_added) do
      changed_state
    else
      %{
        changed_state
        | past_decisive_rounds: [round_move_added | changed_state.past_decisive_rounds]
      }
    end
  end

  defp check_for_winner(rounds) do
    %{player1_wins: player1_wins, player2_wins: player2_wins} =
      Enum.reduce(rounds, %{player1_wins: 0, player2_wins: 0}, fn round, wins ->
        winner = evaluate_round(round.player1_choice, round.player2_choice)

        if winner == :player1 do
          %{wins | player1_wins: wins.player1_wins + 1}
        else
          %{wins | player2_wins: wins.player2_wins + 1}
        end
      end)

    cond do
      player1_wins == 2 -> :player1
      player2_wins == 2 -> :player2
      true -> :none
    end
  end

  defp evaluate_round(player1_choice, player2_choice) do
    cond do
      player1_choice == :rock && player2_choice == :scissors ->
        :player1

      player1_choice == :rock && player2_choice == :paper ->
        :player2

      player1_choice == :paper && player2_choice == :rock ->
        :player1

      player1_choice == :paper && player2_choice == :scissors ->
        :player2

      player1_choice == :scissors && player2_choice == :paper ->
        :player1

      player1_choice == :scissors && player2_choice == :rock ->
        :player2
    end
  end
end
