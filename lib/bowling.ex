defmodule Bowling do
  def score([]), do: 0
  def score([[f, s|_]|others]) when f + s == 10, do: f + s + hd(hd(others)) + score(others)
  def score([[f, s|_]|others]), do: f + s + score(others)
end
