defmodule Hangman do
  def score_guess({secret, correct, wrong, tries}, guess) do
    if String.contains?(secret, guess) do
      {secret, correct<>guess, wrong, tries}
    else
      {secret, correct, wrong<>guess, tries-1}
    end
  end
end
