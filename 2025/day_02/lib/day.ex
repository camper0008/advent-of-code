defmodule Day do
  use Application

  def start(_type, _args) do
    Part2.main()
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
