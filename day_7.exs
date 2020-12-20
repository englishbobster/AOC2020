#! /usr/bin/elixir

defmodule Day7 do

  def load_bag_rules() do
    questions = File.read!("./resources/bag_rules.txt")
    questions
    |> String.trim()
    |> String.split("\n")
  end

  '''
  should parse a bag rule of type:
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags. => [:shiny_gold, {:dark_olive, 1}, {:vibrant_plum, 2}]
    bright white bags contain 1 shiny gold bag. => [:bright_white, {:shiny_gold, 1}]
    faded blue bags contain no other bags. => [:faded_blue]
  '''
  def parse_bag_rule(rule_str) do
    rule_str
    |> String.split([" bags contain ", " bag, ", " bags.", " bags, ", " bag.", "no other bags."], [trim: true])
    |> Enum.map(fn bag_str -> process_bag_string(bag_str) end)
  end
  defp process_bag_string(bag_str) do
    split = String.split(bag_str, " ")
    case length(split) do
      2 -> description_as_atom(split)
      3 -> bag_tuple(split)
      _ -> {}
    end
  end
  defp bag_tuple([nr, desc, colour]) do
    {description_as_atom([desc, colour]), String.to_integer(nr)}
  end
  defp description_as_atom(bag_desc) do
    bag_desc
    |> Enum.join("_")
    |> String.to_atom()
  end

  def collect_bag_rules() do
    load_bag_rules()
    |> Enum.map(fn rule -> parse_bag_rule(rule) end)
  end



  def find_parent_bag([parent | children], child_bag) do
    case Enum.reduce(children, false, fn child, acc -> acc || contains_child(child, child_bag) end) do
      true -> [parent]
      false -> []
    end
  end
  defp contains_child({desc, _}, child_bag) do
    if desc == child_bag, do: true, else: false
  end

end

# with tests
ExUnit.start()
defmodule Day5.BoardingPassTest do
  use ExUnit.Case

  test "find the parent bag for a given rule and child" do
    assert Day7.find_parent_bag(
             [:wavy_fuchsia, {:shiny_magenta, 3}, {:wavy_red, 4}, {:faded_gold, 4}, {:posh_red, 4}],
             :faded_gold
           )
           == [:wavy_fuchsia]
  end

  test "return empty list when no child found" do
    assert Day7.find_parent_bag(
             [:wavy_fuchsia, {:shiny_magenta, 3}, {:wavy_red, 4}, {:faded_gold, 4}, {:posh_red, 4}],
             :NO_CHILD
           )
           == []
  end

  test "return empty list when only parent present" do
    assert Day7.find_parent_bag(
             [:wavy_fuchsia],
             :NO_CHILD
           )
           == []
  end

  test "parse a single rule" do
    assert Day7.parse_bag_rule("light red bags contain 1 bright white bag, 2 muted yellow bags, 5 drab coral bags.")
           == [:light_red, {:bright_white, 1}, {:muted_yellow, 2}, {:drab_coral, 5}]
  end

  test "parse another rule" do
    assert Day7.parse_bag_rule("shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.")
           == [:shiny_gold, {:dark_olive, 1}, {:vibrant_plum, 2}]
  end

  test "parse a rule with one child bag" do
    assert Day7.parse_bag_rule("dark lime bags contain 3 muted magenta bags.")
           == [:dark_lime, {:muted_magenta, 3}]
  end

  test "parse single bag rule" do
    assert Day7.parse_bag_rule("faded blue bags contain no other bags.")
           == [:faded_blue]
  end
end

#First star!!
IO.inspect(Day7.collect_bag_rules(), [{:pretty, true}, {:limit, :infinity}, {:width, 150}])

#Second star!!
