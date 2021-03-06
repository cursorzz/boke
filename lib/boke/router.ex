defmodule Boke.Router do

  use Plug.Router

  use Plug.ErrorHandler

  plug Plug.Logger, log: :debug
  plug Plug.Static, at: "/static", from: "priv/static"

  plug :match
  plug :dispatch

  get "/" do
    header = EEx.eval_file("layout/header.html.eex", [])
    footer = EEx.eval_file("layout/footer.html.eex", [])

    # 
    content = EEx.eval_file("priv/templates/posts.html.eex", [posts: get_posts()])
    index = EEx.eval_file("layout/index.html.eex", [header: header, content: content, footer: footer])
    send_resp(conn, 200, index)
  end

  get "/posts/:post_title" do
    post = get_post(post_title)
    body = get_template("index", [content: post])
    
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, body)
  end

  # otherwise goes to 404.html page
  match _ do
    send_resp(conn, 404, "oops")
  end

  defp handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    send_resp(conn, conn.status, "you got an error #{IO.inspect reason}")
  end

  def get_posts do
    {:ok, file_names} = File.ls("priv/posts")
    Enum.map(file_names, fn(file) -> 
      Boke.Post.fetch_from_file("priv/posts/" <> file)
    end)
  end

  @posts_path "priv/posts/"
  defp get_post(full_name) do
    post = Boke.Post.fetch_from_file(@posts_path <> "#{full_name}.md")
    Earmark.to_html(post.content)
  end

  @template_path "priv/templates/"
  defp get_template(full_name, opts \\ []) do
    EEx.eval_file(@template_path <> full_name <> ".html.eex", opts)
  end
end
