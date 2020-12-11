defmodule Day3 do

  def load_slope() do
    slope = File.read!("./resources/passwords.txt")
    slope
    |> String.trim()
    |> String.split("\n")
  end
end

defmodule Day3.Slope do
  use Agent

  def start_slope_service(slope_map) do
    Agent.start_link(fn -> {{0, 0}, slope_map} end)
  end

  def step(slope_service, {x, y}) do
    Agent.get_and_update(
      slope_service,
      fn {{x_current, y_current}, slope} ->
        {{{x_current, y_current}, slope}, {{x_current + x, y_current + y}, slope}}
      end
    )
    get_at_current_position(slope_service)
  end

  def current_position(slop_service) do
    Agent.get(slop_service, fn {{x, y}, slope_map} -> {x,y} end )
  end

  def get_at(slope_service, {x, y}) do
    Agent.get(slope_service, fn {_, slope_map} -> find_char_at(slope_map, x, y) end)
  end
  def get_at_current_position(slope_service) do
    Agent.get(slope_service, fn {{x, y}, slope_map} -> find_char_at(slope_map, x, y) end)
  end

  def get_current_position(slope_service) do
    Agent.get(slope_service, fn {position, _} -> position end)
  end

  defp find_char_at(slope_map, x, y) do
    norm_y = (y - 1)
    {:ok, line} = slope_map
                  |> Enum.fetch(norm_y)
    norm_x = rem((x - 1), String.length(line))
    String.at(line, norm_x)
  end

end

# with tests
ExUnit.start()
defmodule Day3.SlopeTest do
  import Day3.Slope
  use ExUnit.Case, async: true

  setup do
    row1 = "#...$.."
    row2 = "..!#..#"
    {:ok, slope_service} = start_slope_service([row1, row2])
    %{slope: slope_service, row1: row1, row2: row2}
  end

  test "get the current position", %{slope: slope_service} do
    assert get_current_position(slope_service) == {0, 0}
  end

  test "slope service query should return a tree", %{slope: slope_service} do
    assert get_at(slope_service, {5, 1}) == "$"
  end

  test "step down the slope and set the position", %{slope: slope_service} do
    assert step(slope_service, {5, 1}) == "$"
    assert current_position(slope_service) == {5,1}
    assert step(slope_service, {5, 1}) == "!"
    assert current_position(slope_service) == {10,2}
  end

  test "slope service query should return a tree when wrap around", %{slope: slope_service, row1: row1} do
    row_wrapped_length = 5 + String.length(row1)
    assert get_at(slope_service, {row_wrapped_length, 1}) == "$"
  end

  test "slope service query should return no tree", %{slope: slope_service} do
    assert get_at(slope_service, {6, 1}) == "."
  end

  test "reached the bottom", %{} do
    assert true == true
  end

end


#First star!!

#Second star!!
