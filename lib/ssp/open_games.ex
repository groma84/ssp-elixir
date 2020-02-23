defmodule OpenGames do
  use Agent

  @me __MODULE__
  @pubsub_name "lobby"

  def start_link([]) do
    Agent.start_link(fn -> Map.new() end, name: @me)
  end

  @spec add(String.t()) :: :ok
  def add(game_id) do
    Agent.update(@me, fn games ->
      updated = Map.put(games, game_id, :open) |> IO.inspect(label: "Agent add")
      Phoenix.PubSub.broadcast(Ssp.PubSub, @pubsub_name, {:update_open_games, Map.keys(updated)})
      updated
    end)
  end

  @spec remove(String.t()) :: :ok
  def remove(game_id) do
    Agent.update(@me, fn games ->
      updated = Map.delete(games, game_id) |> IO.inspect(label: "Agent remove")
      Phoenix.PubSub.broadcast(Ssp.PubSub, @pubsub_name, {:update_open_games, Map.keys(updated)})
      updated
    end)
  end

  @spec get_all() :: [String.t()]
  def get_all() do
    Agent.get(@me, fn games -> Map.keys(games) end)
  end
end
