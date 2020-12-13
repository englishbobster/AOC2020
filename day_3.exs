defmodule Day3 do

  def load_slope() do
    slope = File.read!("./resources/slope_map.txt")
    slope
    |> String.trim()
    |> String.split("\n")
  end

  def count_trees(step_x_y) do
    slope_map = load_slope()
    {:ok, slope_service} = Day3.Slope.start_slope_service(slope_map)
    1..length(slope_map)
    |> Enum.map(fn _val -> Day3.Slope.step(slope_service, step_x_y) end)
    |> Enum.filter(fn terrain -> terrain == "#" end)
    |> Enum.count()
  end

  def count_for_multiple_slopes(list_of_slopes) do
    list_of_slopes |> Enum.map(fn slope -> count_trees(slope) end)
    |> Enum.reduce(1, fn cnt, acc -> acc * cnt end)
  end

end

defmodule Day3.Slope do
  use Agent

  def start_slope_service(slope_map) do
    Agent.start_link(fn -> {{1, 1}, slope_map} end)
  end

  def step(slope_service, {x, y}) do
    Agent.update(
      slope_service,
      fn {{x_current, y_current}, slope} -> {{x_current + x, y_current + y}, slope} end
    )
    get_at_current_position(slope_service)
  end

  def current_position(slope_service) do
    Agent.get(slope_service, fn {{x, y}, _slope_map} -> {x, y} end)
  end

  def get_at_current_position(slope_service) do
    Agent.get(slope_service, fn {{x, y}, slope_map} -> find_char_at(slope_map, x, y) end)
  end

  defp find_char_at(slope_map, x, y) do
    norm_y = (y - 1)
    case Enum.fetch(slope_map, norm_y) do
      {:ok, line} ->
        norm_x = rem((x - 1), String.length(line))
        String.at(line, norm_x)
      :error ->
        "." #assume that we stop in snow at the bottom of the slope
    end
  end

end

# with tests
ExUnit.start()
defmodule Day3.SlopeTest do
  import Day3.Slope
  use ExUnit.Case, async: true

  setup do
    row1 = "#...#.."
    row2 = "...#.!#"
    row3 = "...$.#."
    {:ok, slope_service} = start_slope_service([row1, row2, row3])
    %{slope: slope_service}
  end

  test "step down the slope and set the position", %{slope: slope_service} do
    assert step(slope_service, {5, 1}) == "!"
    assert current_position(slope_service) == {6, 2}
    assert step(slope_service, {5, 1}) == "$"
    assert current_position(slope_service) == {11, 3}
  end

end

#First star!!
IO.puts(Day3.count_trees({3, 1}))

#Second star!!
IO.puts(Day3.count_for_multiple_slopes([{1, 1},{3, 1},{5, 1},{7, 1},{1, 2}] ))
