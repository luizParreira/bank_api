defmodule BankApi.Web.TransactionsControllerTest do
  use BankApi.Web.ConnCase

  @account %{name: "Jhon Snow"}
  @params %{amount: "150.0", description: "some description", date: 1503099932}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, account} = Bank.create_checking_account(@account)
    {:ok, conn: conn, checking_account: account}
  end

  describe "credit/2" do

    test "account exitsts and transaction is valid", {conn: conn, checking_account: account} do
      conn = post conn, price_path(conn, :credit, %{@params | checking_account_id: accout.id})

      assert json_response(conn, 200)["data"] == "sucess"
    end

    test "account does not exist" do
    end

    test "bad request" do
    end
  end
end

