defmodule BankApi.Bank.Credit do
  @moduledoc """
  The module responsible for crediting an amount into a users account
  """

  alias BankApi.Bank
  alias BankApi.Bank.ParamsCaster

  def credit(id, amount, date, desc) do
    %{checking_account_id: id, amount: amount, description: desc, date: date}
    |> Bank.create_transaction
  end
end
