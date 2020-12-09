defmodule Day1 do
  def read_expenses() do
    contents = File.read!("./resources/expense_report.txt")
    contents
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.to_integer(s) end)
  end

  def process_expenses(expenses) do
    process_expenses(expenses, {})
  end

  defp process_expenses(_, {a, b}) when b != 0 do
    a * b
  end
  defp process_expenses([], results) do
    results
  end
  defp process_expenses([h | t], _) do
    result = t
             |> Enum.find(0, fn val -> val + h == 2020 end)
    current_result = {h, result}
    process_expenses(t, current_result)
  end

  defp sum_expenses(expenses) do
    sum_expenses(expenses, [])
  end
  defp sum_expenses([], results) do
    results
  end
  defp sum_expenses([h | t], results) do
    result = t
             |> Enum.reduce([], fn val, acc -> acc ++ [{h, val, h + val}] end)
    results = results ++ result
    sum_expenses(t, results)
  end
  defp sum_total_single(expenses, {a, b, total}) do
    expenses
    |> Enum.map(fn val -> {a, b, val, total + val} end)
  end
  def sum_total(expenses) do
    {a, b, c, _} = sum_expenses(expenses)
                   |> Enum.map(fn se -> sum_total_single(expenses, se) end)
                   |> Enum.flat_map(&Function.identity/1) # is &(&1) better?
                   |> Enum.find(fn {_, _, _, total} -> total == 2020 end)

    a * b * c
  end
end

exp = Day1.read_expenses()

#First star!!
Day1.process_expenses(exp)
|> IO.puts

#Second star!!
Day1.sum_total(exp)
|> IO.puts
