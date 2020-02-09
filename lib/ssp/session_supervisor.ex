defmodule SessionSupervisor do
  use DynamicSupervisor

  @me __MODULE__

  def start_link(init_arg) do
    DynamicSupervisor.start_link(@me, init_arg, name: @me)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end

  @spec new_session(String.t(), String.t(), String.t()) ::
          :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def new_session(session_id, player1_id, player1_name) do
    OpenSessions.add(session_id)
    start_child(session_id, player1_id, player1_name)
  end

  def end_session(session_id) do
    [{pid, _}] = Registry.lookup(SessionRegistry, session_id)
    OpenSessions.remove(session_id)
    DynamicSupervisor.terminate_child(@me, pid)
  end

  defp start_child(session_id, player1_id, player1_name) do
    DynamicSupervisor.start_child(
      @me,
      {Session, session_id: session_id, player1_id: player1_id, player1_name: player1_name}
    )
  end
end
