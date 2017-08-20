defmodule BankApi.Bank.BuildStatement do
  @moduledoc """
  Module responsible for building statement for the API response
  """

  alias BankApi.Bank
  alias Bank.DateParser

  def build(id), do: build(id, nil, nil)
  def build(id, start_date, end_date) do
    id
    |> Bank.list_transactions(start_date, end_date)
    |> Enum.group_by(&date/1, &transactions/1)
    |> Enum.map(fn {date, transactions} -> build_statement(id, date, transactions) end)
  end

  defp build_statement(id, date, transactions) do
    %{"date" => timestamp_to_date_string(date),
     "transactions" => transactions,
      "balance" => Bank.calculate_balance(id, DateParser.end_of_day!(date))}
  end

  defp timestamp_to_date_string(date) do
    date
    |> DateTime.from_unix!
    |> DateTime.to_date
    |> Date.to_string
  end

  defp date(transaction) do
    transaction.date
    |> DateParser.start_of_day!
    |> DateTime.to_unix
  end

  defp transactions(transaction) do
    %{"description" => transaction.description,
      "amount" => Decimal.to_float(transaction.amount),
      "ts" => DateTime.to_unix(transaction.date)}
  end
end
