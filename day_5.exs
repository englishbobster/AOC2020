#! /usr/bin/elixir

defmodule Day5 do
  use Bitwise

  def load_boarding_passes() do
    passes = File.read!("./resources/boarding_passes.txt")
    passes
    |> String.trim()
    |> String.split("\n")
  end

  def find_row(row_str) do
    find_partition(row_str, 127)
  end

  def find_column(col_str) do
    find_partition(col_str, 7)
  end

  defp find_partition(partition_str, high) do
    {max, min} = partition_str
                          |> String.graphemes()
                          |> Enum.reduce({high, 0}, fn ch, acc -> partition(ch, acc) end)
    if (max == min), do: max, else: 0
  end
  defp partition(ch, {max, min}) do
    case ch do
      "F" -> {max - ((max - min) >>> 1) - 1, min}
      "L" -> {max - ((max - min) >>> 1) - 1, min}
      "B" -> {max, ((max - min) >>> 1) + min + 1}
      "R" -> {max, ((max - min) >>> 1) + min + 1}
      _ -> "something went terribly wrong!"
    end
  end

  def calculate_boarding_pass_id(boarding_pass_str) do
    row = boarding_pass_str |> String.slice(0..6) |> find_row()
    column = boarding_pass_str |> String.slice(7..9) |> find_column()
    row * 8 + column
  end

  def find_highest_boarding_pass_id() do
    load_boarding_passes()
    |> Enum.map(fn pass -> calculate_boarding_pass_id(pass) end)
    |> Enum.max
  end

  def find_missing_boarding_pass_id() do
    ordered_ids = load_boarding_passes()
    |> Enum.map(fn pass -> calculate_boarding_pass_id(pass) end)
    |> Enum.sort

    List.first(ordered_ids)..List.last(ordered_ids)
    |> Enum.find(fn id -> !Enum.member?(ordered_ids, id) end)
  end

end

# with tests
ExUnit.start()
defmodule Day5.BoardingPassTest do
  use ExUnit.Case

  test "find correct row 44" do
    assert Day5.find_row("FBFBBFF") == 44
  end

  test "find correct row 70" do
    assert Day5.find_row("BFFFBBF") == 70
  end

  test "find correct row 14" do
    assert Day5.find_row("FFFBBBF") == 14
  end

  test "find correct row 102" do
    assert Day5.find_row("BBFFBBF") == 102
  end

  test "find correct column 5" do
    assert Day5.find_column("RLR") == 5
  end

  test "find correct column 7" do
    assert Day5.find_column("RRR") == 7
  end

  test "find correct column 4" do
    assert Day5.find_column("RLL") == 4
  end

end

#First star!!
IO.puts(Day5.find_highest_boarding_pass_id())

#Second star!!
IO.puts(Day5.find_missing_boarding_pass_id())
