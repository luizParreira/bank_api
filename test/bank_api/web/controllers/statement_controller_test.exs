defmodule BankApi.Web.StatementControllerTest do
  use BankApi.Web.ConnCase

  alias BankApi.Bank
  alias BankApi.TransactionsHelper

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, account} = Bank.create_checking_account(%{name: "Jhon snow"})
    TransactionsHelper.create_transactions(account.id)
    {:ok, conn: conn, id: account.id}
  end

  describe "statement/2" do

    test "when there is no date passed in, returns all statements by date", %{conn: conn, id: id} do
      conn = get conn, statement_path(conn, :statement, id)

      expected_response = [
        %{"transactions" => [%{"description" => "payment from Jose", "amount" => 302.0, "ts" => 1268834400}],
          "balance" => 302.0, "date" => "2010-03-17"},
        %{"transactions" => [%{"description" => "Deposit", "amount" => 150.0, "ts" => 1271340000}],
          "date" => "2010-04-15",  "balance" => 452.0},
        %{"transactions"=> [%{"description" => "Went out for drinks", "amount" => -150.0, "ts" => 1271512800},
                            %{"description" => "payment from Ana","amount" => 213.5, "ts" => 1271548740}],
          "date" => "2010-04-17", "balance" => 515.5},
        %{"transactions" => [%{"description" => "Bought books on Amazon", "amount" => -150.0, "ts" => 1271599200}],
          "date" => "2010-04-18", "balance" => 365.5},
        %{"transactions" => [%{"description" => "Deposit" ,"amount" => 200.5,"ts" => 1271707200}],
          "date" => "2010-04-19", "balance" => 566.0}]


      assert json_response(conn, 200)["data"] == expected_response
    end

    test "when there are dates passed in, returns statements by date", %{conn: conn, id: id} do
      params = %{"start_date" => "2010-04-15", "end_date" => "2010-04-18"}
      conn = get conn, statement_path(conn, :statement, id, params)

      expected_response = [
        %{"transactions" => [%{"description" => "Deposit", "amount" => 150.0, "ts" => 1271340000}],
          "date" => "2010-04-15",  "balance" => 452.0},
        %{"transactions"=> [%{"description" => "Went out for drinks", "amount" => -150.0, "ts" => 1271512800},
                            %{"description" => "payment from Ana","amount" => 213.5, "ts" => 1271548740}],
          "date" => "2010-04-17", "balance" => 515.5},
        %{"transactions" => [%{"description" => "Bought books on Amazon", "amount" => -150.0, "ts" => 1271599200}],
          "date" => "2010-04-18", "balance" => 365.5}]


      assert json_response(conn, 200)["data"] == expected_response
    end

    test "when there is no account", %{conn: conn, id: _id} do
      conn = get conn, statement_path(conn, :statement, 99)
      not_found_json = %{"type" => "NotFound", "message" => "Account does not exist"}

      assert json_response(conn, 404)["error"] == not_found_json
    end
  end
end

