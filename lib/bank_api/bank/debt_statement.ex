defmodule BankApi.Bank.DebtStatement do
  @moduledoc """
  Module responsible for building user's debt for the API response
  """

  alias BankApi.Bank
  alias Bank.Statement

  def build(id) do
    id
    |> Statement.build
    |> Enum.map(&({&1["balance"], &1["date"]}))
    |> build_statement([])
    |> Enum.map(fn {sd, ed, p} -> %{"start" => sd, "end" => end_date(ed), "principal" => p} end)
    |> Enum.reverse
  end

  defp build_statement([], debts), do: debts
  defp build_statement([{balance, date}], debts) when balance < 0 do
    build_statement([], [{date, nil, abs(balance)} | debts])
  end

  defp build_statement([{balance, date}, {next_balance, next_date}], debts) when balance < 0 and balance != next_balance do
    build_statement([{next_balance, next_date}], [{date, next_date, abs(balance)} | debts])
  end

  defp build_statement([{balance, date}, {next_balance, next_date} | statements], debts) when balance < 0 and balance != next_balance do
    build_statement([{next_balance, next_date} | statements], [{date, next_date, abs(balance)} | debts])
  end

  defp build_statement([{_balance, _date} | statements], debts) do
    build_statement(statements, debts)
  end

  defp end_date(nil), do: nil
  defp end_date(date) do
    with {:ok, date} <- Date.from_iso8601(date),
         date <- Date.add(date, -1)
    do
      Date.to_string(date)
    end
  end
end
