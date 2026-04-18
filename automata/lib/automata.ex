defmodule Automata do
    def example_nfa do
        {
            [:Q0, :Q1, :Q2, :Q3],
            [:a, :b],
            %{
                {:Q0, :a} => [:Q0, :Q1],
                {:Q0, :b} => [:Q0],
                {:Q1, :b} => [:Q2],
                {:Q2, :b} => [:Q3]
            },
            :Q0,
            [:Q3]
        }
    end

    def example_nfa2 do
      {
        [:Q0, :Q1, :Q2, :Q3, :Q4, :Q5, :Q6, :Q7, :Q8, :Q9, :Q10],
        [:a, :b],
        %{
            {:Q0, :epsilon} => [:Q7, :Q1],
            {:Q1, :epsilon} => [:Q2, :Q3],
            {:Q2, :a} => [:Q4],
            {:Q3, :b} => [:Q5],
            {:Q4, :epsilon} => [:Q6],
            {:Q5, :epsilon} => [:Q6],
            {:Q6, :epsilon} => [:Q1, :Q7],
            {:Q7, :a} => [:Q8],
            {:Q8, :b} => [:Q9],
            {:Q9, :b} => [:Q10]
        },
        :Q0,
        [:Q10]
      }
    end

    def powerset([]), do: [[]]

    def powerset([h|t]) do
        ps = powerset(t)
        ps ++ Enum.map(ps, fn ss -> [h|ss] end)
    end

    def determize({q, sigma, delta, q0, f}) do
        q_prime =
            powerset(q)
            |> Enum.map(&Enum.sort/1)
            |> Enum.sort_by(fn subset -> {length(subset), subset} end)

        delta_prime =
            for subset <- q_prime,
                a <- sigma,
                into: %{} do
                    result =
                        subset
                        |> Enum.flat_map(fn q ->
                           Map.get(delta, {q, a}, [])
                        end)
                        |> Enum.uniq()
                        |> Enum.sort()
                    {{subset, a}, result}
                end
        f_prime =
            Enum.filter(q_prime, fn subset ->
                Enum.any?(subset, fn q -> q in f end)
            end)

        {q_prime, sigma, delta_prime, [q0], f_prime}
    end

    def e_closure({_q, _sigma, delta, _q0, _f}, states) do
        traverse_epsilon(delta, states, states)
        |> Enum.uniq()
        |> sort_states()
    end

    defp traverse_epsilon(_delta, [], visited), do: visited

    defp traverse_epsilon(delta, [current | rest], visited) do
        neighbors = Map.get(delta, {current, :epsilon}, [])
        new =
            Enum.filter(neighbors, fn n -> n not in visited end)
            traverse_epsilon(delta, rest ++ new, visited ++ new)
    end

    defp sort_states(states) do
        Enum.sort_by(states, fn state ->
            state
            |> Atom.to_string()
            |> String.replace("Q", "")
            |> String.to_integer()
        end)
    end

    def e_determinize({_q, sigma, delta, q0, _f} = automata) do
        start =
            e_closure(automata, [q0])
            |> sort_states()

        {visited, delta_prime} =
            explore(delta, sigma, automata, start, [], %{})

        q_prime =
            visited
            |> Enum.map(&sort_states/1)
            |> Enum.sort_by(fn subset -> {length(subset), subset} end)

        f = elem(automata, 4)

        f_prime =
            Enum.filter(q_prime, fn subset ->
                Enum.any?(subset, &(&1 in f))
            end)

        {q_prime, sigma, delta_prime, start, f_prime}
    end


    defp explore(delta, sigma, automata, current, visited, delta_prime) do
        current = sort_states(current)

        if current in visited do
            {visited, delta_prime}
        else
            visited = [current | visited]

            Enum.reduce(sigma, {visited, delta_prime}, fn a, {vis, d_acc} ->
                move =
                    current
                    |> Enum.flat_map(fn q -> Map.get(delta, {q, a}, []) end)

                closure =
                    e_closure(automata, move)
                    |> sort_states()

                d_acc = Map.put(d_acc, {current, a}, closure)

                cond do
                    closure == [] ->
                        {vis, d_acc}
                    closure in vis ->
                        {vis, d_acc}
                    true ->
                        explore(delta, sigma, automata, closure, vis, d_acc)
                end
            end)
        end
    end
end
