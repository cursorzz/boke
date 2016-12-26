defmodule Boke do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(__MODULE__, [], function: :run)
      # Starts a worker by calling: Boke.Worker.start_link(arg1, arg2, arg3)
      # worker(Boke.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Boke.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def run do
    routes = [
      {"/", Boke.Handler, []},
      {"/static/[...]", :cowboy_static, {:priv_dir, :boke, "static"}}
    ]

    dispatch = :cowboy_router.compile([{:_, routes}])

    opts = [port: 8000]
    env = [dispatch: dispatch]

    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])
  end
end

defmodule Boke.Handler do
  def init({:tcp, :http}, req, opts) do
    headers = [{"content-type", "text/plain"}]
    body = "Hello program!"
    {:ok, resp} = :cowboy_req.reply(200, headers, body, req)
    {:ok, resp, opts}
  end

  def handle(req, state) do
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
