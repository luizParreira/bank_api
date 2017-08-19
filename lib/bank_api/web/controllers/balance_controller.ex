defmodule BankApi.Web.BalanceController do
  use BankApi.Web, :controller

  alias BankApi.Bank
  alias Bank.CheckingAccount
  alias Bank.Transaction

  action_fallback BankApi.Web.FallbackController

  def balance(conn, %{"checking_account_id" => id}) do
    with %CheckingAccount{} <- Bank.get_checking_account(id),
         balance <- Bank.calculate_balance(id) do
      render(conn, "balance.json", balance: balance)
    else
      nil -> {:error, :not_found}
       _  -> {:error, :bad_request}
    end
  end
end
