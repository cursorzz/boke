require IEx
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
    headers = [{"content-type", 'text/html'}]
    IO.puts "index page"
    content = File.ls!("priv/pages/") |> IO.puts |>
    print_articles("")
    {:ok, resp} = :cowboy_req.reply(200, headers, content, req)
  end

  def get_file("GET", param, req) do
    headers = [{"content-type", "text/html"}]
    {:ok, file} = File.read "priv/pages/#{param}.md"
    body = Earmark.to_html(file)
    body = EEx.eval_file "priv/templates/index.html.eex", [content: body]
    {:ok, resp} = :cowboy_req.reply(200, headers, body, req)
  end

  def print_articles([h|t], index_content) do
    link = "<a href='#{h}'>#{h}</a>"
    print_articles t, index_content <> link
  end

  def print_articles([], index_content), do: index_content

  def terminate(_reason, _req, _state) do
    :ok
  end
end
