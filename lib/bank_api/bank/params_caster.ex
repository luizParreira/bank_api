defmodule BankApi.Bank.ParamsCaster do
  @moduledoc """
  Module responsible for casting transaction params to desirable types
  """

  def cast(params) do
    cast_params(params)
  end

  defp cast_params(%{amount: amount, date: date, description: desc, checking_account_id: id}) do
    %{amount: cast_amount(amount),
      date: cast_date(date),
      description: desc,
      checking_account_id: id}
  end
  defp cast_params(_), do: %{}


  defp cast_amount(amount) when is_float(amount) do
    validate_amount(amount)
  end
  defp cast_amount(amount) when is_bitstring(amount) do
    amount
    |> String.to_float
    |> validate_amount
  end
  defp cast_amount(_), do: nil

  defp validate_amount(amount) when amount >= 0, do: amount
  defp validate_amount(_), do: nil

  defp cast_date(date) when is_integer(date) do
    date
    |> DateTime.from_unix
    |> _cast_date
  end
  defp cast_date(date), do: date

  defp _cast_date({:ok, date}), do: date
  defp _cast_date({:error, _error}), do: nil
end

