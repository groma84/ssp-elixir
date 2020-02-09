defmodule Play do
  def play(session_state, current_round, playing_player, move) do
    if moves_already_made?(current_round) do
      {:moves_already_made, session_state}
    else
      move_added =
        case get_player(playing_player, session_state) do
          :player1 -> %{current_round | player1_choice: move}
          :player2 -> %{current_round | player2_choice: move}
        end

      if moves_already_made?(move_added) do
        updated_rounds = update_rounds(session_state, move_added)

        case check_for_winner(updated_rounds.past_decisive_rounds) do
          :none -> {:continue_playing, updated_rounds}
          :player1 -> {:game_over, %{updated_rounds | winner: session_state.player1}}
          :player2 -> {:game_over, %{updated_rounds | winner: session_state.player2}}
        end
      else
        {:waiting_for_other_player, %{session_state | current_round: move_added}}
      end
    end
  end

  @spec moves_already_made?(Round.t()) :: boolean()
  defp moves_already_made?(round) do
    !(is_nil(round.player1_choice) || is_nil(round.player2_choice))
  end

  defp get_player(%Player{player_id: playing_player_id}, state) do
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
