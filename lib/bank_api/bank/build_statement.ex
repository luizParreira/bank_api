defmodule BankApi.Bank.BuildStatement do
  @moduledoc """
  Module responsible for building statement for the API response
  """

  alias BankApi.Bank

  def build(id), do: build(id, nil, nil)
  def build(id, start_date, end_date) do
    id
    |> Bank.list_transactions(start_date, end_date)
    |> Enum.group_by(&date_group_by/1, &build_day_statement/1)
    |> Enum.map(fn {k, v} -> calculate_current_balance(id, k, v) end)
  end

  defp calculate_current_balance(id, date, transactions) do
    %{date |> DateTime.from_unix! |> DateTime.to_date |> Date.to_string => transactions,
      "balance" => Bank.calculate_balance(id, date |> DateTime.from_unix! |> DateTime.to_date)}
  end

  defp date_group_by(transaction) do
    transaction.date
    |> DateTime.to_unix
  end

  defp build_day_statement(transaction) do
    %{"description" => transaction.description,
      "amount" => transaction.amount |> Decimal.to_float,
      "ts" => DateTime.to_unix(transaction.date)}
  end
end
