defmodule BowlingTest do
  use ExUnit.Case
  doctest Bowling

  test "gutter game" do
    game = List.duplicate([0,0], 9) ++ [[0,0,nil]]
    assert Bowling.score(game) == 0
  end
end
