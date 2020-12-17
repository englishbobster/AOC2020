defmodule Day7 do

  def load_bag_rules() do
    questions = File.read!("./resources/bag_rules.txt")
    questions
    |> String.trim()
    |> String.split("\n")
  end

  def parse_bag_rule(rule_str) do
    [head | tail] = rule_str
                    |> String.split("bags contain")

    primary_bag = head
                  |> String.trim()
                  |> bag_colour_as_atom()
    List.first(tail)
    |> String.trim()
    |> String.split(", ")
    |> Enum.map(fn str -> process_secondary_bag_string(str) end)
    |> List.insert_at(0, primary_bag)
  end
  defp process_secondary_bag_string(bag_str) do
    String.split(bag_str, " ")
    |> Enum.take(3)
    |> bag_tuple()
  end
  defp bag_tuple([nr, desc, colour]) do
    bag = [desc, colour]
          |> Enum.join("_")
          |> String.to_atom()
    {bag, String.to_integer(nr)}
  end
  defp bag_colour_as_atom(bag_desc) do
    bag_desc
    |> String.split(" ")
    |> Enum.join("_")
    |> String.to_atom()
  end

end

# with tests
ExUnit.start()
defmodule Day5.BoardingPassTest do
  use ExUnit.Case

  test "parse a single rule" do
    assert Day7.parse_bag_rule("light red bags contain 1 bright white bag, 2 muted yellow bags, 5 drab coral bags.")
           == [:light_red, {:bright_white, 1}, {:muted_yellow, 2}, {:drab_coral, 5}]
  end

  test "parse another rule" do
    assert Day7.parse_bag_rule("shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.")
           == [:shiny_gold, {:dark_olive, 1}, {:vibrant_plum, 2}]
  end
end

#First star!!

#Second star!!
