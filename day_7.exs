#! /usr/bin/elixir

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
    |> process_secondary_bag()
    |> List.insert_at(0, primary_bag)
  end
  defp process_secondary_bag(str) do
    case String.contains?(str, ",") do
      true ->
        String.split(str, ", ")
        |> Enum.map(fn str -> process_secondary_bag_string(str) end)
      false -> []
    end
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

  def collect_bag_rules() do
    load_bag_rules()
    |> Enum.map(fn rule -> parse_bag_rule(rule) end)
  end

  def search_bag_tree(rules, bag) do
    search_bag_tree(rules, [bag], [])
  end
  def search_bag_tree(_, [], result) do
    result
  end
  def search_bag_tree(rules, bags, result) do
    new_bags = bags |> Enum.map(fn bag -> find_parent_bags(rules, bag) end)
    |> Enum.flat_map(fn x -> x end)
    search_bag_tree(rules, new_bags, result ++ new_bags)
  end
  def find_parent_bags(rules, bag_description) do
    IO.inspect(bag_description)
    rules
    |> Enum.map(fn rule -> get_parent_bag(rule, bag_description) end)
  end
  def get_parent_bag(rule, bag_desc) do
    rule
    |> Enum.find_value(
         fn bag -> case bag do
                     {colour, _} -> if colour == bag_desc, do: List.first(rule)
                     _ -> nil
                   end
         end
       )
  end

  def bag_colours() do
    collect_bag_rules()
    |> search_bag_tree(:shiny_gold)
  end

end

# with tests
ExUnit.start()
defmodule Day5.BoardingPassTest do
  use ExUnit.Case

  test "from parsed rule, return parent to given bag description" do
    assert Day7.get_parent_bag(
             [:dull_turquoise, {:striped_magenta, 4}, {:dull_gray, 2}, {:shiny_indigo, 3}],
             :dull_gray
           )
           == :dull_turquoise
  end

  test "from parsed rule, return nil if no bag description" do
    assert Day7.get_parent_bag(
             [:dull_turquoise, {:striped_magenta, 4}, {:dull_gray, 2}, {:shiny_indigo, 3}],
             :I_AM_NOT_IN_THE_RULE
           )
           == nil
  end

  test "parse a single rule" do
    assert Day7.parse_bag_rule("light red bags contain 1 bright white bag, 2 muted yellow bags, 5 drab coral bags.")
           == [:light_red, {:bright_white, 1}, {:muted_yellow, 2}, {:drab_coral, 5}]
  end

  test "parse another rule" do
    assert Day7.parse_bag_rule("shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.")
           == [:shiny_gold, {:dark_olive, 1}, {:vibrant_plum, 2}]
  end

  test "parse single bag rule" do
    assert Day7.parse_bag_rule("faded blue bags contain no other bags.")
           == [:faded_blue]
  end
end

#First star!!
IO.inspect(Day7.find_parent_bags(Day7.collect_bag_rules(), :shiny_gold), [{:pretty, true}, {:limit, :infinity}])

#Second star!!
