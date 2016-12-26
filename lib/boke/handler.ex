defmodule Boke.Handler do
  def init({:tcp, :http}, req, opts) do
    {:ok, req, opts}
  end

  def handle(req, state) do
    {method, req} = :cowboy_req.method(req)
    {params, req} = :cowboy_req.binding(:filename, req)
    IO.inspect params
    {:ok, req} = get_file(method, params, req)
    {:ok, req, state}
  end

  def get_file("GET", :undefined, req) do
    headers = [{"content-type", 'text/plain'}]
    body = "Oops. Article not found!"
    {:ok, resp} = :cowboy_req.reply(200, headers, body, req)
  end

  def get_file("GET", param, req) do
    headers = [{"content-type", "text/html"}]
    {:ok, file} = File.read "priv/pages/#{param}.md"
    {:ok, resp} = :cowboy_req.reply(200, headers, file, req)
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
