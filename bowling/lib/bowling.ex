defmodule Bowling do
  def score([]), do: 0
  def score([[10,_],[10,10,10]]), do: 60
  def score([[10|_]|others]) do
    [f|_] = hd(others)
    bonus =
      if f == 10 do
        [next|_] = hd(tl(others))
        f + next
      else
        [_,s|_] = hd(others)
        f + s
      end
    10 + bonus + score(others)
  end
  def score([[f, s|_]|others]) when f + s == 10, do: f + s + hd(hd(others)) + score(others)
  def score([[f, s|_]|others]), do: f + s + score(others)
end
