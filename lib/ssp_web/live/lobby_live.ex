defmodule SspWeb.LobbyLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(SspWeb.LobbyView, "index.html", assigns)
  end

  def mount(_params, %{}, socket) do
    temperature = 42
    {:ok, assign(socket, :temperature, temperature)}
  end
end
