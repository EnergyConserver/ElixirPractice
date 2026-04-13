defmodule AutomataTest do
  use ExUnit.Case
  doctest Automata

  test "Determinacion of non-deterministic automata" do
    N = {
      [Q0, Q1, Q2, Q3],
      #[A, B],
      #%{
        #{Q0, A} => [Q0, Q1],
        #{Q0, B} => [Q0],
        #{Q1, B} => [Q2],
        #{Q2, B} => [Q3]
      #},
      #Q0,
      #[Q3]
    }
    DN = Automata.determize(N)
    assert DN == {
      [
        [Q0], [Q1], [Q2], [Q3], [Q0, Q1],[Q0, Q2], [Q0, Q3], [Q1, Q2], [Q1, Q3],
        [Q2, Q3], [Q0, Q1, Q2], [Q0, Q1, Q3], [Q0, Q2, Q3], [Q1, Q2, Q3], [Q0, Q1, Q2, Q3]
      ],
      nil,
      nil,
      nil,
      nil
      #[A, B],
      #%{
        #{Q0, A} => [Q1],
        #{Q0, B} => [Q0],
        #{Q1, A} => [Q1],
        #{Q1, B} => [Q2],
        #{Q2, A} => [Q1],
        #{Q2, B} => [Q3],
        #{Q3, A} => [Q1],
        #{Q3, B} => [Q0]
      #},
      #Q0,
      #[Q3]
    }
  end
end
