defmodule Automata do
    def determize({q, _sigma, _delta, _q0, _f}) do
        q_prime =
            Enum.reduce(q, [[]], fn x, acc -> acc++ Enum.map(acc, fn subset -> [x | subset] end) end)
            |> Enum.reject(&(&1 == []))
            |> Enum.map(&Enum.sort/1)
            |> Enum.uniq()
        {q_prime}
    end
end
