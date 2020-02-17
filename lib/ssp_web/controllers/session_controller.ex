defmodule SspWeb.SessionController do
  use SspWeb, :controller

  def new(conn, %{"player_id" => player_id, "player_name" => player_name}) do
    session_id = SessionSupervisor.new_session(player_id, player_name)

    live_render(conn, SspWeb.SessionLive,
      session: %{
        "session_id" => session_id,
        "player_id" => player_id,
        "player_name" => player_name
      }
    )
  end
end
