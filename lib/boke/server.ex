defmodule Boke.Server do

  def start(port, _whatever) do
    IO.puts "start server"
    import Supervisor.Spec, warn: false
    Application.ensure_all_started :plug

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Boke.Router, [], [port: port])
    ]

    opts = [strategy: :one_for_one, name: Boke.DevServer.Supervisor]
    Supervisor.start_link(children, opts)

    # keep the server running
    looper
  end

  defp looper, do: looper
end
