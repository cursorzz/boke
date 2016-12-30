# based on https://github.com/rizafahmi/elixirdose-cli
defmodule Boke.Cli do
  @moduledoc """
  This module contains entry point for command line
  """

  def main(args) do
    IO.puts args
    [task|opts] = args
    case task do
      "init" -> do_init(opts)
      "server" -> do_serve(opts)
      "serve" -> do_serve(opts)
      "help" -> do_process(:help)
      _ -> do_process(:help)
    end
    # opts |> parse_opts |> do_process
  end

  def do_init(args) do
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

# defmodule Boke.Server do

#   def run(port) do
#   end
# end
