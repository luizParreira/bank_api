defmodule BankApi.Web.StatementController do
  use BankApi.Web, :controller

  alias BankApi.Bank
  alias Bank.CheckingAccount
  alias Bank.Statement
  alias Bank.DateParser

  action_fallback BankApi.Web.FallbackController

  def statement(conn, params) do
    build_statement(conn, params)
  end

  defp build_statement(conn, %{"checking_account_id" => id, "start_date" => sd, "end_date" => ed}) do
    build(conn, id, sd, ed)
  end
  defp build_statement(conn, %{"checking_account_id" => id}), do: build(conn, id)

  defp build(conn, id, start_date, end_date) do
    with (account = %CheckingAccount{}) <- Bank.get_checking_account(id),
         {:ok, start_date, end_date} <- DateParser.parse(start_of: start_date, end_of: end_date),
         statement <- Statement.build(account.id, start_date, end_date)
    do
      render(conn, "statement.json", statement: statement)
    else
      nil -> {:error, :not_found}
      _ -> {:error, :bad_request}
    end
  end
  defp build(conn, id), do: build(conn, id, nil, nil)
end
