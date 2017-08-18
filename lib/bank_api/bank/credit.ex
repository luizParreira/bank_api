defmodule BankApi.Bank.Credit do
  @moduledoc """
  The module responsible for crediting an amount into a users account
  """

  alias BankApi.Bank
  alias BankApi.Bank.ParamsCaster

  def credit(params) do
    params
    |> ParamsCaster.cast
    |> Bank.create_transaction
  end
end
