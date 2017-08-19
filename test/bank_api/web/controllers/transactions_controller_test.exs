defmodule BankApi.Web.TransactionsControllerTest do
  use BankApi.Web.ConnCase

  alias BankApi.Bank
  alias BankApi.Repo
  alias Bank.Transaction

  @account %{name: "Jhon Snow"}
  @params %{description: "some description", date: 1503099932}

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, account} = Bank.create_checking_account(@account)
    {:ok, conn: conn, checking_account: account, amount: "150.0"}
  end

  describe "credit/2" do
    test "transaction is valid and is credated", %{conn: conn, checking_account: account, amount: amount} do
      conn = post conn, transactions_path(conn, :credit, account.id, amount, @params)
      attributes = %{checking_account_id: account.id, amount: Decimal.new("150.0")}

      assert json_response(conn, 200)["data"] == "success"
      assert Repo.get_by(Transaction, attributes)
    end

    test "account does not exist", %{conn: conn, checking_account: _account, amount: amount} do
      conn = post conn, transactions_path(conn, :credit, 99, amount, @params)
      not_found_json = %{"type" => "NotFound", "message" => "Account does not exist"}

      assert json_response(conn, 404)["error"] == not_found_json
    end

    test "bad request", %{conn: conn, checking_account: account, amount: _amount} do
      conn = post conn, transactions_path(conn, :credit, account.id, "not an amount", @params)
      bad_request_json = %{"type" => "BadRequest", "message" => "bad request"}

      assert json_response(conn, 400)["error"] == bad_request_json
    end
  end

  describe "debit/2" do
    test "transaction is valid and is credated", %{conn: conn, checking_account: account, amount: amount} do
      conn = post conn, transactions_path(conn, :debit, account.id, amount, @params)
      attributes = %{checking_account_id: account.id, amount: Decimal.new("-150.0")}

      assert json_response(conn, 200)["data"] == "success"
      assert Repo.get_by(Transaction, attributes)
    end

    test "account does not exist", %{conn: conn, checking_account: _account, amount: amount} do
      conn = post conn, transactions_path(conn, :debit, 99, amount, @params)
      not_found_json = %{"type" => "NotFound", "message" => "Account does not exist"}

      assert json_response(conn, 404)["error"] == not_found_json
    end

    test "bad request", %{conn: conn, checking_account: account, amount: _amount} do
      conn = post conn, transactions_path(conn, :debit, account.id, "not an amount", @params)
      bad_request_json = %{"type" => "BadRequest", "message" => "bad request"}

      assert json_response(conn, 400)["error"] == bad_request_json
    end
  end
end

