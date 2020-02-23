defmodule GameSupervisor do
  use DynamicSupervisor

  @me __MODULE__

  def start_link(init_arg) do
    DynamicSupervisor.start_link(@me, init_arg, name: @me)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end

  @spec new_game(String.t(), String.t()) :: String.t()
  def new_game(player1_id, player1_name) do
    game_id = UUID.uuid4()
    start_child(game_id, player1_id, player1_name)
    OpenGames.add(game_id)
    game_id
  end

  def end_game(game_id) do
    case Registry.lookup(GameRegistry, game_id) do
      [{pid, _}] ->
        OpenGames.remove(game_id)
        DynamicSupervisor.terminate_child(@me, pid)

      [] ->
        :ok
    end
  end

  defp start_child(game_id, player1_id, player1_name) do
    DynamicSupervisor.start_child(
      @me,
      {Game, game_id: game_id, player1_id: player1_id, player1_name: player1_name}
    )
  end
end
