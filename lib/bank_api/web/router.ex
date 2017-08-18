defmodule BankApi.Web.Router do
  use BankApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankApi.Web do
    pipe_through :api

    post "/transactions/:checking_account_id/credit/:amount", TransactionsController, :credit
    #post "/transactions/:checking_account_id/debit/:amount", TransactionsController, :debit
  end
end
