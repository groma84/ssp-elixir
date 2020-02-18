defmodule Game do
  use GenServer

  # STARTUP
  @spec start_link([], [
          {:player1_name, String.t()} | {:player1_id, String.t()} | {:game_id, String.t()}
        ]) ::
          :ignore | {:error, any} | {:ok, pid}
  def start_link([], game_id: game_id, player1_id: player1_id, player1_name: player1_name) do
    GenServer.start_link(
      __MODULE__,
      [game_id: game_id, player1_id: player1_id, player1_name: player1_name],
      name: game_pid(game_id)
    )
  end

  @impl true
  @spec init([{:game_id, String.t()} | {:player1_id, String.t()} | {:player1_name, String.t()}]) ::
          {:ok, GameData.t()}
  def init(game_id: game_id, player1_id: player1_id, player1_name: player1_name) do
    {:ok,
     %GameData{
       game_id: game_id,
       player1: %Player{name: player1_name, player_id: player1_id}
     }}
  end

  # CLIENT
  @spec join_game(String.t(), String.t(), String.t()) :: :ok
  def join_game(game_id, player2_id, player2_name) do
    GenServer.call(
      game_pid(game_id),
      {:join_game, %Player{name: player2_name, player_id: player2_id}}
    )
  end

  @spec update_move(String.t(), Player.t(), Move.move()) :: :ok
  def update_move(game_id, player, move) do
    GenServer.call(
      game_pid(game_id),
      {:update_move, player, move}
    )
  end

  def get(game_id) do
    GenServer.call(
      game_pid(game_id),
      {:get_data}
    )
  end

  # SERVER
  @impl true
  def handle_call({:join_game, new_player = %Player{}}, _from, state) do
    if is_nil(state.player2) do
      OpenGames.remove(state.game_id)
      new_state = %{state | player2: new_player}
      {:reply, :ok, new_state}
    else
      {:reply, :game_already_full, state}
    end
  end

  @impl true
  def handle_call(
        {:update_move, playing_player = %Player{}, move},
        _from,
        state = %{current_round: current_round}
      ) do
    {result, new_state} = Play.play(state, current_round, playing_player, move)

    {:reply, result, new_state}
  end

  @impl true
  def handle_call(
        {:get_data},
        _from,
        state
      ) do
    {:reply, state, state}
  end

  # HELPER
  defp game_pid(game_id) do
    {:via, Registry, {GameRegistry, game_id}}
  end
end