defmodule BankApi.Web.Router do
  use BankApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", BankApi.Web do
    pipe_through :api

    post "/transactions/:checking_account_id/credit/:amount", TransactionsController, :credit
    post "/transactions/:checking_account_id/debit/:amount", TransactionsController, :debit

    get "/checking_account/:checking_account_id/balance", BalanceController, :balance
    get "/checking_account/:checking_account_id/statement", StatementController, :statement
  end
end
