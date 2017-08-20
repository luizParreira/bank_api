defmodule BankApi.Web.StatementController do
  use BankApi.Web, :controller

  alias BankApi.Bank
  alias Bank.CheckingAccount
  alias Bank.Transaction
  alias Bank.BuildStatement

  action_fallback BankApi.Web.FallbackController

  def statement(conn, %{"checking_account_id" => id, "start_date" => sd, "end_date" => ed}) do
    with (account = %CheckingAccount{}) <- Bank.get_checking_account(id),
         {{:ok, start_date}, {:ok, end_date}} <- {Date.from_iso8601(sd), Date.from_iso8601(ed)},
         statement <- BuildStatement.build(id, start_date, end_date) do
      render(conn, "statement.json", statement: statement)
    else
      nil -> {:error, :not_found}
      _ -> {:error, :bad_request}
    end
  end
end
