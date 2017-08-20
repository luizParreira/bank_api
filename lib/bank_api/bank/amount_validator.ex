defmodule BankApi.Bank.AmountValidator do
  @moduledoc """
  Helper module responsible for validating if the amount passed in as param in the API is positive
  """

  def validate(amount, op) do
    amount
    |> Float.parse
    |> _validate(op)
  end

  def _validate(:error, _op), do: :error
  def _validate({amount, _}, _operations) when amount <= 0, do: :error
  def _validate({amount, _}, :credit), do: {:ok, amount}
  def _validate({amount, _}, :debit), do: {:ok, -amount}
end
