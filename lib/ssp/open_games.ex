defmodule OpenGames do
  use Agent

  @me __MODULE__

  def start_link([]) do
    Agent.start_link(fn -> Map.new() end, name: @me)
  end

  @spec add(String.t()) :: :ok
  def add(game_id) do
    Agent.update(@me, fn games -> Map.put(games, game_id, :open) end)
  end

  @spec remove(String.t()) :: :ok
  def remove(game_id) do
    Agent.update(@me, fn games -> Map.delete(games, game_id) end)
  end

  @spec get_all() :: [String.t()]
  def get_all() do
    Agent.get(@me, fn games -> Map.keys(games) end)
  end
end
