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
    |> build_debt_statement([])
    |> Enum.map(fn {sd, ed, p} -> %{"start" => sd, "end" => ed, "principal" => p} end)
    |> Enum.reverse
  end

  def build_debt_statement([], debts), do: debts
  def build_debt_statement([{balance, date}], debts) when balance < 0 do
    build_debt_statement([], [{date, nil, abs(balance)} | debts])
  end
  def build_debt_statement([{balance_a, date_a}, {balance_b, date_b}], debts) when balance_a < 0 and balance_a != balance_b do
    build_debt_statement([{balance_b, date_b}], [{date_a, date_b, abs(balance_a)} | debts])
  end
  def build_debt_statement([{balance_a, sd}, {balance_b, ed} | statements], debts) when balance_a < 0 and balance_a != balance_b do
    build_debt_statement([{balance_b, ed} | statements], [{sd, ed, abs(balance_a)} | debts])
  end
  def build_debt_statement([{_balance, _date} | statements], debts) do
    build_debt_statement(statements, debts)
  end
end
