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

  def find_bag_colours_for(rules, bag) do
    find_all_bag_colours(rules, [bag], [])
    |> Enum.uniq()
  end
  def find_all_bag_colours(_, [], results) do
    results
  end
  def find_all_bag_colours(rules, bags, results) do
    new_bags = bags
               |> Enum.flat_map(fn bag -> find_parent_bags(rules, bag) end)
    find_all_bag_colours(rules, new_bags, results ++ new_bags)
  end

  def find_parent_bags(rules, child_bag) do
    rules
    |> Enum.flat_map(fn rule -> find_parent_bag(rule, child_bag) end)
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

  def get_children_to_parent_bags(rules, parent_bag) do
    get_children_to_parent_bags(rules, [parent_bag], [])
  end
  def get_children_to_parent_bags(_, [], results) do
    results
  end
  def get_children_to_parent_bags(rules, parent_bag_list, results) do
    children = parent_bag_list
               |> Enum.flat_map(fn bag -> get_children_to_parent_bag(rules, bag) end)
    get_children_to_parent_bags(rules, Keyword.keys(children), results ++ children)
  end
  def get_children_to_parent_bag(rules, parent_bag) do
    [_ | children] = find_parent_rule(rules, parent_bag)
    children
  end
  def find_parent_rule(rules, parent_bag) do
    rules
    |> Enum.find(fn rule -> List.first(rule) == parent_bag end)
  end

  def count_bags(current_results, children) do

  end

end

# with tests
ExUnit.start()
defmodule Day5.BagRuleTest do
  use ExUnit.Case

  setup do
    rule_strings = [
      "light red bags contain 1 bright white bag, 2 muted yellow bags.",
      "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
      "bright white bags contain 1 shiny gold bag.",
      "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
      "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
      "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
      "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
      "faded blue bags contain no other bags.",
      "dotted black bags contain no other bags."
    ]
    %{rule_strings: rule_strings}
  end

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

  test "try the finding the bag colours for the given example", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> Day7.parse_bag_rule(rule) end)

    assert Day7.find_bag_colours_for(rules, :shiny_gold) == [:bright_white, :muted_yellow, :light_red, :dark_orange]
  end

  test "find the children to the parent rule", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> Day7.parse_bag_rule(rule) end)
    assert Day7.get_children_to_parent_bag(rules, :shiny_gold) == [{:dark_olive, 1}, {:vibrant_plum, 2}]
  end

  test "find the children to the parent rule when no children", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> Day7.parse_bag_rule(rule) end)
    assert Day7.get_children_to_parent_bag(rules, :dotted_black) == []
  end

  test "get a structured list of child bags and values", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> Day7.parse_bag_rule(rule) end)
    assert Day7.get_children_to_parent_bags(rules, :shiny_gold) == 32
  end

end

rules = Day7.collect_bag_rules()
#First star!!
list_of_all_parents = Day7.find_bag_colours_for(rules, :shiny_gold)
IO.puts(Enum.count(list_of_all_parents))

#Second star!!
#IO.inspect(Day7.get_children_to_parent_bags(rules, :shiny_gold))
