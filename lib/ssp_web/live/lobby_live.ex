defmodule SspWeb.LobbyLive do
  use Phoenix.LiveView

  @pubsub_name "lobby"

  def render(assigns) do
    Phoenix.View.render(SspWeb.LobbyView, "index.html", assigns)
  end

  def mount(_params, %{}, socket) do
    player_id = UUID.uuid4()
    :ok = Phoenix.PubSub.subscribe(Ssp.PubSub, @pubsub_name)

    {:ok,
     assign(
       socket,
       changeset: Player.changeset(%Player{}, %{player_id: player_id}),
       valid: false,
       open_games: Lobby.list_open_games()
     )}
  end

  def handle_event("validate", %{"player" => %{"player_name" => player_name}}, socket) do
    changeset = Player.changeset(socket.assigns.changeset, %{name: player_name})

    IO.inspect(changeset)

    {:noreply, assign(socket, changeset: changeset, valid: changeset.valid?)}
  end

  def handle_info({:update_open_games, open_games}, socket) do
    formatted_open_games = Lobby.format_games_for_display(open_games)
    {:noreply, assign(socket, open_games: formatted_open_games)}
  end
end
