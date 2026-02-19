defmodule Bowling do
  def score([]), do: 0
  def score([[f, s|_]|others]), do: f + s + score(others)
end
