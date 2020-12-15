defmodule Day5 do
  use Bitwise

  def load_boarding_passes() do
    passes = File.read!("./resources/boarding_passes.txt")
    passes
    |> String.trim()
    |> String.split("\n")
  end

  def find_row(partition_str) do
    {max, min} = partition_str
                          |> String.graphemes()
                          |> Enum.reduce( {127, 0}, fn ch, acc -> partition(ch, acc) end)
    if (max == min), do: max, else: 0
  end
  defp partition(ch, {max, min}) do
    case ch do
      "F" -> {max - ((max - min) >>> 1) - 1, min}
      "B" -> {max, ((max - min) >>> 1) + min + 1}
      _ -> "something went terribly wrong!"
    end
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
end


#First star!!

#Second star!!
