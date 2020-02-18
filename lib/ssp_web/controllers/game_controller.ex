defmodule SspWeb.GameController do
  use SspWeb, :controller

  def new(conn, %{"player_id" => player_id, "player_name" => player_name}) do
    game_id = GameSupervisor.new_game(player_id, player_name)

    redirect(conn, to: Routes.game_path(conn, :play, player_id, game_id))
  end

  def play(conn, %{"player_id" => player_id, "game_id" => game_id}) do
    live_render(conn, SspWeb.GameLive,
      session: %{
        "game_id" => game_id,
        "player_id" => player_id
      }
    )
  end

  def join(conn, %{"player_id" => player_id, "player_name" => player_name, "game_id" => game_id}) do
    Game.join_game(game_id, player_id, player_name)

    redirect(conn, to: Routes.game_path(conn, :play, player_id, game_id))
  end
end
