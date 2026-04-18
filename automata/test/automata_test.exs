defmodule AutomataTest do
  use ExUnit.Case
  doctest Automata

  test "Determinacion of non-deterministic automata" do
    non_automata = Automata.example_nfa()
    determine_automata = Automata.determize(non_automata)
    assert determine_automata ==
      {
        [
          [], [:Q0], [:Q1], [:Q2], [:Q3], [:Q0, :Q1],[:Q0, :Q2], [:Q0, :Q3], [:Q1, :Q2], [:Q1, :Q3],
          [:Q2, :Q3], [:Q0, :Q1, :Q2], [:Q0, :Q1, :Q3], [:Q0, :Q2, :Q3], [:Q1, :Q2, :Q3], [:Q0, :Q1, :Q2, :Q3]
        ],
        [:a, :b],
        %{
          {[], :a} => [],
          {[], :b} => [],
          {[:Q0], :a} => [:Q0, :Q1],
          {[:Q0], :b} => [:Q0],
          {[:Q1], :a} => [],
          {[:Q1], :b} => [:Q2],
          {[:Q2], :a} => [],
          {[:Q2], :b} => [:Q3],
          {[:Q3], :a} => [],
          {[:Q3], :b} => [],
          {[:Q0, :Q1], :a} => [:Q0, :Q1],
          {[:Q0, :Q1], :b} => [:Q0, :Q2],
          {[:Q0, :Q2], :a} => [:Q0, :Q1],
          {[:Q0, :Q2], :b} => [:Q0, :Q3],
          {[:Q0, :Q3], :a} => [:Q0, :Q1],
          {[:Q0, :Q3], :b} => [:Q0],
          {[:Q1, :Q2], :a} => [],
          {[:Q1, :Q2], :b} => [:Q2, :Q3],
          {[:Q1, :Q3], :a} => [],
          {[:Q1, :Q3], :b} => [:Q2],
          {[:Q2, :Q3], :a} => [],
          {[:Q2, :Q3], :b} => [:Q3],
          {[:Q0, :Q1, :Q2], :a} => [:Q0, :Q1],
          {[:Q0, :Q1, :Q2], :b} => [:Q0, :Q2, :Q3],
          {[:Q0, :Q1, :Q3], :a} => [:Q0, :Q1],
          {[:Q0, :Q1, :Q3], :b} => [:Q0, :Q2],
          {[:Q0, :Q2, :Q3], :a} => [:Q0, :Q1],
          {[:Q0, :Q2, :Q3], :b} => [:Q0, :Q3],
          {[:Q1, :Q2, :Q3], :a} => [],
          {[:Q1, :Q2, :Q3], :b} => [:Q2, :Q3],
          {[:Q0, :Q1, :Q2, :Q3], :a} => [:Q0, :Q1],
          {[:Q0, :Q1, :Q2, :Q3], :b} => [:Q0, :Q2, :Q3]
        },
        [:Q0],
        [
          [:Q3],
          [:Q0, :Q3],
          [:Q1, :Q3],
          [:Q2, :Q3],
          [:Q0, :Q1, :Q3],
          [:Q0, :Q2, :Q3],
          [:Q1, :Q2, :Q3],
          [:Q0, :Q1, :Q2, :Q3]
        ]
      }
  end

  test "epsilon closure simple chain" do
    automata = {
      [:Q0, :Q1, :Q2],
      [:a, :b],
      %{
        {:Q0, :epsilon} => [:Q1],
        {:Q1, :epsilon} => [:Q2]
      },
      :Q0,
      [:Q2]
    }
    assert Automata.e_closure(automata, [:Q0]) == [:Q0, :Q1, :Q2]
  end

  test "epsilon closure with cycle" do
    automata = {
      [:Q0, :Q1],
      [:a],
      %{
        {:Q0, :epsilon} => [:Q1],
        {:Q1, :epsilon} => [:Q0]
      },
      :Q0,
      []
    }
    assert Automata.e_closure(automata, [:Q0]) == [:Q0, :Q1]
  end

  test "Determinacion of non-deterministic automata with epsilon transitions" do
    non_automata = Automata.example_nfa2()
    edetermine_automata = Automata.e_determinize(non_automata)
    assert edetermine_automata ==
      {
        [
          [:Q0, :Q1, :Q2, :Q3, :Q7],
          [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7],
          [:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8],
          [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q10],
          [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q9]
        ],
        [:a, :b],
        %{
          {[:Q0, :Q1, :Q2, :Q3, :Q7], :a} => [:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8],
          {[:Q0, :Q1, :Q2, :Q3, :Q7], :b} => [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7],
          {[:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8], :a} => [:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8],
          {[:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8], :b} => [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q9],
          {[:Q1, :Q2, :Q3, :Q5, :Q6, :Q7], :a} => [:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8],
          {[:Q1, :Q2, :Q3, :Q5, :Q6, :Q7], :b} => [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7],
          {[:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q9], :a} => [:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8],
          {[:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q9], :b} => [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q10],
          {[:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q10], :a} => [:Q1, :Q2, :Q3, :Q4, :Q6, :Q7, :Q8],
          {[:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q10], :b} => [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7]
        },
        [:Q0, :Q1, :Q2, :Q3, :Q7],
        [
          [:Q1, :Q2, :Q3, :Q5, :Q6, :Q7, :Q10]
        ]
      }
  end
end
