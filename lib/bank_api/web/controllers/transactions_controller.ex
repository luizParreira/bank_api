defmodule BankApi.Web.TransactionsController do
  use BankApi.Web, :controller

  alias BankApi.Bank
  alias Bank.CheckingAccount
  alias Bank.Transaction
  alias Bank.AmountValidator

  action_fallback BankApi.Web.FallbackController

  def credit(conn, params) do
    transact(conn, :credit, params)
  end

  def debit(conn, params) do
    transact(conn, :debit, params)
  end

  defp transact(conn, op, %{"checking_account_id" => id, "date" => date, "description" => desc, "amount" => amount}) do
    with %CheckingAccount{} <- Bank.get_checking_account(id),
         {date, _} <- Integer.parse(date),
         {:ok, date} <- DateTime.from_unix(date),
         {:ok, amount} <- AmountValidator.validate(amount, op),
         (transaction = %Transaction{}) <- Bank.transact(id, amount, date, desc)
    do
      render(conn, "success.json", transaction: transaction)
    else
      nil -> {:error, :not_found}
       _  -> {:error, :bad_request}
    end
  end
end
