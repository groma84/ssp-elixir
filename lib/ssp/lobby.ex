defmodule Lobby do
  def list_open_session() do
    OpenSessions.get_all()
  end
end
