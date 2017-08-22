defmodule BankApi.Bank.BuildDebt do
  @moduledoc """
  Module responsible for building user's debt for the API response
  """

  alias BankApi.Bank
  alias Bank.BuildStatement

  def build(id) do
    id
    |> BuildStatement.build
    |> Enum.map(&({&1["balance"], &1["date"]}))
    |> _build([])
    |> Enum.map(fn {sd, ed, p} -> %{"start" => sd, "end" => ed, "principal" => p} end)
    |> Enum.reverse
  end

  def _build([], debt), do: debt
  def _build([{balance, date}], debts) when balance < 0 do
    _build([], [{date, nil, abs(balance)} | debts])
  end
  def _build([{balance_a, date_a}, {balance_b, date_b}], debts) when balance_a < 0 and balance_a != balance_b do
    _build([{balance_b, date_b}], [{date_a, date_b, abs(balance_a)} | debts])
  end
  def _build([{balance_a, sd}, {balance_b, ed} | statements], debts) when balance_a < 0 and balance_a != balance_b do
    _build([{balance_b, ed} | statements], [{sd, ed, abs(balance_a)} | debts])
  end
  def _build([{_balance, _date} | statements], debts) do
    _build(statements, debts)
  end
end
