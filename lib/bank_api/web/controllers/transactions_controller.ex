defmodule BankApi.Web.TransactionsController do
  use BankApi.Web, :controller

  alias BankApi.Bank
  alias BankApi.Bank.CheckingAccount
  alias BankApi.Bank.Transaction

  def credit(conn, %{"checking_account_id" => id, "date" => date, "description" => desc, "amount" => amount}) do
    with %CheckingAccount{} <- Bank.get_checking_account(id),
         {:ok, date} <- DateTime.from_unix(date),
         %Transaction{} <- Bank.credit(id, amount, date, desc) do
      render(conn, %{data: "success"})
    else
      nil -> {:error, :not_found}
       _  -> {:error, :bad_request}
    end
  end
end
