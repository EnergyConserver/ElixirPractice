defmodule Tablature do
  def parse(tab) do
    tab
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      [s, notes] = String.split(line, "|", parts: 2)

      Regex.scan(~r/\d+/, notes, return: :index)
      |> Enum.map(fn [{i, l}] -> {i, s <> String.slice(notes, i, l)} end)
    end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map_join(" ", &elem(&1, 1))
  end
end
