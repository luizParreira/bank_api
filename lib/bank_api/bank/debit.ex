defmodule BankApi.Bank.Debit do
  @moduledoc """
  The module responsible for debiting an amount into a users account
  """

  alias BankApi.Bank
  alias BankApi.Bank.ParamsCaster

  def debit(params) do
    params
    |> ParamsCaster.cast
    |> debit_transaction
    |> Bank.create_transaction
  end

  defp debit_transaction(params) do
    %{params | amount: (if params[:amount], do: -params.amount, else: nil)}
  end
end
