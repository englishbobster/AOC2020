defmodule Day6 do

  def load_group_questions() do
    questions = File.read!("./resources/group_questions.txt")
    questions
    |> String.trim()
    |> String.split("\n\n")
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
IO.puts("first star goes here")

#Second star!!
IO.puts("second star goes here")
