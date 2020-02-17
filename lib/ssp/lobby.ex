defmodule Lobby do
  def list_open_session() do
    Enum.map(OpenSessions.get_all(), fn session_id ->
      session = Session.get(session_id)
      %{session_id: session_id, player1_name: session.player1_name}
    end)
  end
end
