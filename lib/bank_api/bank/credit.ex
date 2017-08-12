defmodule BankApi.Bank.Credit do
  @moduledoc """
  The module responsible for crediting an amount into a users account
  """

  alias BankApi.Bank

  def credit(params) do
    params
    |> process_params
    |> Bank.create_transaction
  end

  defp process_params(%{amount: amount, date: date, description: desc, checking_account_id: id}) do
    %{amount: validate_amount(amount),
      date: parse_date(date),
      description: desc,
      checking_account_id: id }
  end
  defp process_params(_), do: %{}

  def validate_amount(nil), do: nil
  def validate_amount(amount) do
    if String.to_float(amount) >= 0, do: amount, else: nil
  end
  def validate_amount(_), do: nil


  def parse_date(nil), do: nil
  def parse_date(date) when is_integer(date) do
    date
    |> DateTime.from_unix
    |> _parse_date
  end

  def parse_date(date) when is_bitstring(date) do
    date
    |> String.to_integer
    |> DateTime.from_unix
  end

  defp _parse_date({:ok, date}), do: date
  defp _parse_date({:error, _error}), do: nil
end
