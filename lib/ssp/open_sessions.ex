defmodule OpenSessions do
  use Agent

  @me __MODULE__

  def start_link([]) do
    Agent.start_link(fn -> Map.new() end, name: @me)
  end

  @spec add(String.t()) :: :ok
  def add(session_id) do
    Agent.update(@me, fn sessions -> Map.put(sessions, session_id, :open) end)
  end

  @spec remove(String.t()) :: :ok
  def remove(session_id) do
    Agent.update(@me, fn sessions -> Map.delete(sessions, session_id) end)
  end

  @spec get_all() :: [String.t()]
  def get_all() do
    Agent.get(@me, fn sessions -> Map.keys(sessions) end)
  end
end
