defmodule Boke.PostMeta do
  defstruct [:title, :description]
end

defmodule Boke.Post do

  defstruct meta: %Boke.PostMeta{}, content: ""

  def fetch_from_file(file) do
    {:ok, file} = File.read(file)
    {meta, content} = parse_info(file)
    %__MODULE__{meta: meta, content: content}
  end

  def parse_info(file_string) do
    file_string
    |> String.split("\n")
    |> _parse(false, "", "")
  end

  def _parse([h|t], false, "", "") do
    if match_line(h) do
      _parse(t, true, "", "")
    else
      {"", ""}
    end
  end

  def _parse([h|t], false, meta_string, content_string) do
    _parse(t, false, meta_string, content_string <> h <> "\n")
  end

  def _parse([h|t], true, meta_string, content_string) do
    if match_line(h) do
      _parse(t, false, meta_string, content_string)
    else
      _parse(t, true, meta_string <> h <> "\n", content_string)
    end
  end

  def _parse([], _state, meta_string, content_string) do
    {YamlElixir.read_from_string(meta_string), content_string}
  end

  def match_line(line) do
    line
    |> String.trim
    |> String.to_charlist
    |> Enum.all?(&(&1 == 45))
  end
end

