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

  defp process_expenses(_, {a,b}) when b != 0 do
    a * b
  end
  defp process_expenses([], results) do
    results
  end
  defp process_expenses([h | t], _) do
    result = t |> Enum.find(0, fn val -> val + h == 2020 end)
    current_result = {h, result}
    process_expenses(t, current_result)
  end

end

exp = Day1.read_expenses()

#First star!!
Day1.process_expenses(exp) |> IO.puts

#Second star!!
