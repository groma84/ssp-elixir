defmodule SspWeb.LobbyController do
  use SspWeb, :controller

  def index(conn, _params) do
    live_render(conn, SspWeb.LobbyLive)
  end
end
