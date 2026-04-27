defmodule Hangman do
  def score_guess({secret, correct, wrong, tries}, guess) do
    {secret, correct<>guess, wrong, tries}
  end
end
