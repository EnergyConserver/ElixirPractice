defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "Works with 'hangman' and one correct letter" do
    assert {"hangman", "h", "", 9} = Hangman.score_guess({"hangman", "", "", 9}, "h")
    assert {"hangman", "a", "", 9} = Hangman.score_guess({"hangman", "", "", 9}, "a")
    assert {"hangman", "n", "", 9} = Hangman.score_guess({"hangman", "", "", 9}, "n")
    assert {"hangman", "g", "", 9} = Hangman.score_guess({"hangman", "", "", 9}, "g")
    assert {"hangman", "m", "", 9} = Hangman.score_guess({"hangman", "", "", 9}, "m")
  end

  @tag :skip
  test "Works with 'hangman' and two correct letters" do
    assert {"hangman", "ha", "", 9} = {"hangman", "", "", 9} |> Hangman.score_guess("h") |> Hangman.score_guess("a")
    assert {"hangman", "ng", "", 9} = {"hangman", "", "", 9} |> Hangman.score_guess("n") |> Hangman.score_guess("g")
    assert {"hangman", "ah", "", 9} = {"hangman", "", "", 9} |> Hangman.score_guess("a") |> Hangman.score_guess("h")
  end

  @tag :skip
  test "Works with 'hangman' and three correct letters" do
    Enum.map(1..5, fn _ ->
      seq = Enum.take_random(~w[h a n g m], 3)
      corr = Enum.join(seq)
      assert {"hangman", ^corr, "", 9} = Enum.reduce(seq, {"hangman", "", "", 9}, fn letter, acc -> Hangman.score_guess(acc, letter) end)
    end)
  end

  @tag :skip
  test "Works with 'hangman'; correct and incorrect letters" do
    assert {"hangman", "ha", "x", 8} = {"hangman", "", "", 9} |> Hangman.score_guess("h") |> Hangman.score_guess("a") |> Hangman.score_guess("x")
    assert {"hangman", "ng", "w", 8} = {"hangman", "", "", 9} |> Hangman.score_guess("n") |> Hangman.score_guess("w") |> Hangman.score_guess("g")
    assert {"hangman", "ah", "y", 8} = {"hangman", "", "", 9} |> Hangman.score_guess("y") |> Hangman.score_guess("a") |> Hangman.score_guess("h")
  end

  @tag :skip
  test "Works with 'hangman'; correct, incorrect and duplicate letters" do
    assert {"hangman", "ha", "x", 8} = {"hangman", "", "", 9} |> Hangman.score_guess("h") |> Hangman.score_guess("a") |> Hangman.score_guess("x") |> Hangman.score_guess("h")
    assert {"hangman", "ng", "w", 8} = {"hangman", "", "", 9} |> Hangman.score_guess("n") |> Hangman.score_guess("w") |> Hangman.score_guess("w") |> Hangman.score_guess("g")
    assert {"hangman", "ah", "y", 8} = {"hangman", "", "", 9} |> Hangman.score_guess("y") |> Hangman.score_guess("a") |> Hangman.score_guess("h") |> Hangman.score_guess("a")
  end

  @tag :skip
  test "Works with 'hangman' and handles end of game" do
    assert {"hangman", "", "bcdefijkl", 0} = {"hangman", "", "bcdefijkl", 0} |> Hangman.score_guess("h")
    assert {"hangman", "a", "bcefijkl", 0} = {"hangman", "a", "bcefijkl", 0} |> Hangman.score_guess("n") |> Hangman.score_guess("w")
    assert {"hangman", "ahgn", "bcdef", 0} = {"hangman", "ahgn", "bcdef", 0} |> Hangman.score_guess("y")
  end

  @tag :skip
  test "Formats feedback" do
    assert "hang-an" == Hangman.format_feedback({"hangman", "ahgn", "bcdef", 0})
    assert "--i-tst--e" == Hangman.format_feedback({"flintstone", "etis", "bc", 4})
    assert "f-i-tsto-e" == Hangman.format_feedback({"flintstone", "etisof", "bc", 2})
    assert "-------" == Hangman.format_feedback({"hangman", "", "bcdefijkl", 0})
  end
end
