#! /usr/bin/elixir

defmodule Day6 do

  def load_group_questions() do
    questions = File.read!("./resources/group_questions.txt")
    questions
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(fn group -> String.split(group, "\n") end)
  end

  def sum_counts_for_questions_anyone_answered() do
    load_group_questions()
    |> Enum.map(fn group_list -> Enum.join(group_list) end)
    |> Enum.map(fn str -> String.graphemes(str) end)
    |> Enum.map(fn grapheme_list -> Enum.uniq(grapheme_list) end)
    |> Enum.map(fn uniq_list -> Enum.count(uniq_list) end)
    |> Enum.sum()
  end

  def sum_counts_for_questions_everyone_answered() do
    load_group_questions()
    |> Enum.map(fn group -> count_questions_answered_by_everyone_in_group(group) end)
    |> Enum.sum()
  end

  defp count_questions_answered_by_everyone_in_group(group) do
    [shortest_list | rest_lists] = group
                                   |> Enum.map(fn questions -> String.graphemes(questions) end)
                                   |> Enum.sort(fn x, y -> length(x) <= length(y) end)
    shortest_list
    |> Enum.reduce(0, fn q, acc -> acc + match_group_questions(rest_lists, q) end)
  end

  defp match_group_questions(group_question_lists, question) do
    question_in_all_lists = group_question_lists
                            |> Enum.reduce(true, fn list, acc -> acc && Enum.member?(list, question) end)
    if (question_in_all_lists == true), do: 1, else: 0
  end

end

#First star!!
IO.puts(Day6.sum_counts_for_questions_anyone_answered())

#Second star!!
IO.puts(Day6.sum_counts_for_questions_everyone_answered())
