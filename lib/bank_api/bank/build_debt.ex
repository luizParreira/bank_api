defmodule BankApi.Bank.BuildDebt do
  @moduledoc """
  Module responsible for building user's debt for the API response
  """

  alias BankApi.Bank

  def build(id) do
    id
    |> Bank.list_transactions
    |> Enum.map(&({Decimal.to_float(&1.amount), &1.date}))
    |> Enum.scan(fn {amount_a, date_a}, {amount_b, date_b} ->
      {amount_a + amount_a, date_a}
    end)
    |> Enum.map(&build_debt_json/1)
  end

  def build_debt_json({amount, date}) when amount < 0 do
    %{"start_date" => DateTime.to_unix(date), "principal" => amount}
  end
  def build_debt_json(_), do: nil
end
