defmodule Tablature do
  def parse(tab) do
    tab
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      [s, notes] = String.split(line, "|", parts: 2)

      Regex.scan(~r/\d+/, notes, return: :index)
      |> Enum.map(fn [{i, l}] -> {i, s <> String.slice(notes, i, l)} end)
    end)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.sort_by(fn {pos, _} -> pos end)
    |> Enum.map_join(" ", fn {_, notes} -> Enum.join(notes, "/") end)
  end
end
