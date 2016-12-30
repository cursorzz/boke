# based on https://github.com/rizafahmi/elixirdose-cli
defmodule Boke.Cli do
  @moduledoc """
  This module contains entry point for command line
  """

  alias Boke.Utils

  def main(args) do
    [task|opts] = args
    case task do
      "init" -> do_init(opts)
      "new" -> do_new(opts)
      "server" -> do_serve(opts)
      "serve" -> do_serve(opts)
      "help" -> do_process(:help)
      _ -> do_process(:help)
    end
    # opts |> parse_opts |> do_process
  end

  def do_init(args) do
  end
  
  @doc "create new post"
  def do_new(args) do
    {_parsed, file_name, _errors} = OptionParser.parse(args)

    path = Utils.posts_path(get_underlined_path(file_name) <> ".md")

    if File.exists?(path) do
      IO.puts path <> " already exist"
    else
      content = """
      ---
      draft = true
      date = "#{DateTime.utc_now |> DateTime.to_iso8601}"
      title = "#{get_title(file_name)}"
      ---
      """
      File.write(path, content, [:write])
      IO.puts "you just create a new post at #{path}"
    end
  end

  @doc "format file name to white seperated string"
  @spec get_title([String.t]) :: String.t
  defp get_title(file_name_list) do
    file_name_list |> Enum.join(" ")
  end
  
  @doc "format file name to underline seperated string"
  @spec get_underlined_path([String.t]) :: String.t
  def get_underlined_path(file_name_list) do
    file_name_list |> Enum.join("_")
  end

  def do_serve(args) do
    {parsed, argv, errors} = OptionParser.parse(args, strict: [port: :integer], aliases: [p: :port])
    port = Keyword.get(parsed, :port, 8000)

    Boke.Server.start(port, nil)
  end

  def parse_args(args) do
    options = OptionParser.parse(args)
  end

  def do_process([name]) do
    IO.puts name
  end

  def do_process(:help) do
    IO.puts """
      Usage:

    """
  end
end
