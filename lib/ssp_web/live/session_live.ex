defmodule SspWeb.SessionLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(SspWeb.SessionView, "index.html", assigns)
  end

  def mount(
        _params,
        initial_game_data,
        socket
      ) do
    IO.inspect(initial_game_data)
    {:ok, assign(socket, initial_game_data)}
  end
end
