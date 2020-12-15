defmodule Day6 do

  def load_group_questions() do
    questions = File.read!("./resources/group_questions.txt")
    questions
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn group -> String.split(group, "\n") end)
  end

  def sum_counts_for_groups_any_answer() do
    load_group_questions()
    |> Enum.map(fn group_list -> Enum.join(group_list) end)
    |> Enum.map(fn str -> String.graphemes(str) end)
    |> Enum.map(fn grapheme_list -> Enum.uniq(grapheme_list) end)
    |> Enum.map(fn uniq_list -> Enum.count(uniq_list) end)
    |> Enum.sum()
  end

end

# with tests
ExUnit.start()
defmodule Day6.Questions do
  use ExUnit.Case

  test "true is true" do
    assert true == true
  end

end

#First star!!
IO.puts(Day6.sum_counts_for_groups_any_answer())

#Second star!!
IO.puts("second star goes here")
