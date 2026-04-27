defmodule Hangman do
  def score_guess(_game, guess) do
    {"hangman", guess, "", 9}
  end
end
