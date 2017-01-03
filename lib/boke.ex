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
      # worker(Agent, [fn -> %{} end, [name: Boke.Site]], id: "boke_site"),
      worker(Agent, [fn -> %{} end, [name: Boke.Posts]], id: "boke_posts")
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

defmodule Boke.Site do

  def get(key) when is_atom(key) do
    Application.get_env(:boke, key)
  end

  def get(key) do
    key
    |> String.to_existing_atom
    |> get
  end
end

defmodule Boke.Posts do
  def init_data() do
    Agent.update(__MODULE__, fn _ -> %{} end)
  end

  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def del(key) do
    Agent.update(__MODULE__, &Map.delete(&1, key))
  end
end
