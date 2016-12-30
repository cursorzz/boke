defmodule Boke.Utils do

  @base_path "priv"

  def posts_path do
    @base_path <> "/posts"
  end

  def posts_path(file) do
    posts_path <> "/" <> file
  end

  def static_path do
    @base_path <> "/static"
  end

  def static_path(file) do
    static_path() <> "/" <> file
  end

  def layout_path do
    @base_path <> "/layout"
  end

  def layout_path(file) do
    layout_path() <> "/" <> file
  end
end
