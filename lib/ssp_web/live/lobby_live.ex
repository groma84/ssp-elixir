defmodule SspWeb.LobbyLive do
  use Phoenix.LiveView

  def render(assigns) do
    Phoenix.View.render(SspWeb.LobbyView, "index.html", assigns)
  end

  def mount(_params, %{}, socket) do
    player_id = UUID.uuid4()

    if connected?(socket) do
      :timer.send_interval(30000, self(), :update)
    end

    {:ok,
     assign(socket,
       changeset: Player.changeset(%Player{}, %{player_id: player_id}),
       valid: false,
       open_games: Lobby.list_open_session()
     )}
  end

  def handle_event("validate", %{"player" => %{"player_name" => player_name}}, socket) do
    changeset = Player.changeset(socket.assigns.changeset, %{name: player_name})

    IO.inspect(changeset)

    {:noreply, assign(socket, changeset: changeset, valid: changeset.valid?)}
  end
end
