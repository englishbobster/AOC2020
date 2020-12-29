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

  ###### here follows solution for second star
  def count_bags(rules, bag_desc) do
    count_bags(rules, [{bag_desc, 1}], [])
  end
  def count_bags(_rules, [], result) do
    result
    |> Enum.reduce(0, fn {val, _}, acc -> acc + val end)
  end
  def count_bags(rules, parent_bags, result) do
    # divide the the parent bags into results for processing later...
    results = parent_bags
              |> Enum.map(fn {desc, val} -> get_children_with_count(rules, {desc, val}) end)
    #... and the children for the tail recursion
    children = results
               |> Enum.flat_map(fn {_score, children} -> children end)
    count_bags(rules, children, result ++ results)
  end

  #find the child rules, calculate the nr of bags on this level, and modify the children values with the parent factor
  def get_children_with_count(rules, {desc, parent_val}) do
    [{_parent, children}] = rules
                            |> Enum.find([], fn [{parent_desc, _value}] -> parent_desc == desc  end)
    nr_of_bags = children
            |> Enum.map(fn {_desc, val} -> val * parent_val end)
            |> Enum.sum()

    {nr_of_bags, update_children_values(children, parent_val)}
  end

  def update_children_values(children, value) do
    children
    |> Enum.map(fn {desc, val} -> {desc, val * value} end)
  end

  #Make the rules more graph like a list of tuples with node and edges
  def modified_rules(old_rules) do
    old_rules
    |> Enum.map(fn rule -> modify_rule(rule) end)
  end
  def modify_rule(old_rule) do
    [head | tail] = old_rule
    [{head, tail}]
  end

end

# with tests
ExUnit.start()
defmodule Day7.BagRuleTest do
  use ExUnit.Case
  import Day7

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
    other_rule_strings = [
      "shiny gold bags contain 2 dark red bags.",
      "dark red bags contain 2 dark orange bags.",
      "dark orange bags contain 2 dark yellow bags.",
      "dark yellow bags contain 2 dark green bags.",
      "dark green bags contain 2 dark blue bags.",
      "dark blue bags contain 2 dark violet bags.",
      "dark violet bags contain no other bags."
    ]
    %{rule_strings: rule_strings, other_rule_strings: other_rule_strings}
  end

  test "count all the bags with other", %{other_rule_strings: other_rule_strings} do
    rules = other_rule_strings
            |> Enum.map(fn rule -> parse_bag_rule(rule) end)
            |> modified_rules()
    assert count_bags(rules, :shiny_gold) == 126
  end

  test "count all the bags", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> parse_bag_rule(rule) end)
            |> modified_rules()
    assert count_bags(rules, :shiny_gold) == 32
  end

  test "given a parent bag, find its children", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> parse_bag_rule(rule) end)
            |> modified_rules()
    assert get_children_with_count(rules, {:shiny_gold, 1}) == {3, [{:dark_olive, 1}, {:vibrant_plum, 2}]}
  end

  test "find the parent bag for a given rule and child" do
    assert find_parent_bag(
             [:wavy_fuchsia, {:shiny_magenta, 3}, {:wavy_red, 4}, {:faded_gold, 4}, {:posh_red, 4}],
             :faded_gold
           )
           == [:wavy_fuchsia]
  end

  test "return empty list when no child found" do
    assert find_parent_bag(
             [:wavy_fuchsia, {:shiny_magenta, 3}, {:wavy_red, 4}, {:faded_gold, 4}, {:posh_red, 4}],
             :NO_CHILD
           )
           == []
  end

  test "return empty list when only parent present" do
    assert find_parent_bag(
             [:wavy_fuchsia],
             :NO_CHILD
           )
           == []
  end

  test "parse a single rule" do
    assert parse_bag_rule("light red bags contain 1 bright white bag, 2 muted yellow bags, 5 drab coral bags.")
           == [:light_red, {:bright_white, 1}, {:muted_yellow, 2}, {:drab_coral, 5}]
  end

  test "parse another rule" do
    assert parse_bag_rule("shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.")
           == [:shiny_gold, {:dark_olive, 1}, {:vibrant_plum, 2}]
  end

  test "parse a rule with one child bag" do
    assert parse_bag_rule("dark lime bags contain 3 muted magenta bags.")
           == [:dark_lime, {:muted_magenta, 3}]
  end

  test "parse single bag rule" do
    assert parse_bag_rule("faded blue bags contain no other bags.")
           == [:faded_blue]
  end

  test "try the finding the bag colours for the given example", %{rule_strings: rule_strings} do
    rules = rule_strings
            |> Enum.map(fn rule -> parse_bag_rule(rule) end)

    assert find_bag_colours_for(rules, :shiny_gold) == [:bright_white, :muted_yellow, :light_red, :dark_orange]
  end

end

rules = Day7.collect_bag_rules()
#First star!!
list_of_all_parents = Day7.find_bag_colours_for(rules, :shiny_gold)
IO.puts(Enum.count(list_of_all_parents))

#Second star!!
modified_rules = Day7.collect_bag_rules()
                 |> Day7.modified_rules()
IO.puts(Day7.count_bags(modified_rules, :shiny_gold))
