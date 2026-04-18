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
end
