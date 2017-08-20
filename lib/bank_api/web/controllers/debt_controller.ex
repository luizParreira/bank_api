defmodule BankApi.Web.DebtController do
  use BankApi.Web, :controller

  alias BankApi.Bank
  alias Bank.CheckingAccount
  alias Bank.BuildDebt

  action_fallback BankApi.Web.FallbackController

  def periods_of_debt(conn, %{"checking_account_id" => id}) do
    with %CheckingAccount{} <- Bank.get_checking_account(id),
         debt <- BuildDebt.build(id)
    do
      render(conn, "debt.json", debt: debt)
    else
      nil -> {:error, :not_found}
      _ -> {:error, :bad_request}
    end
  end
end
