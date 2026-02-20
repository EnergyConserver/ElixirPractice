defmodule Bowling do
  def score([]), do: 0
  def score([[10|_]|others]) do
    [f,s|_] = hd(others)
    10 + f + s + score(others)
  end
  def score([[f, s|_]|others]) when f + s == 10, do: f + s + hd(hd(others)) + score(others)
  def score([[f, s|_]|others]), do: f + s + score(others)
end
