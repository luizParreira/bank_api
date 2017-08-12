defmodule BankApi.Web.Router do
  use BankApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankApi.Web do
    pipe_through :api
  end
end
