defmodule Boke do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # worker(__MODULE__, [], function: :run),
      # Plug.Adapters.Cowboy.child_spec(:http, Boke.Router, [], [port: 8000])
      # worker(Agent, [fn -> %{} end, [name: Boke.Templates]], id: "boke_templates")
      # Starts a worker by calling: Boke.Worker.start_link(arg1, arg2, arg3)
      # worker(Boke.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Boke.Supervisor]
    Supervisor.start_link(children, opts)
    # looper
  end
end
