defmodule Hangman do
  def score_guess({secret, correct, wrong, tries} = game, guess) do
    cond do
      secret =~ guess and correct =~ guess -> game
      secret =~ guess -> {secret, correct<>guess, wrong, tries}
      wrong =~ guess -> game
      true -> {secret, correct, wrong<>guess, tries-1}
    end
  end
end
