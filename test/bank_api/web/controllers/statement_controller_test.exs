defmodule BankApi.Web.StatementControllerTest do
  use BankApi.Web.ConnCase

  alias BankApi.Bank

  @account %{name: "Jhon Snow"}
  @transaction_1 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-15 14:00:00.000000Z], "Etc/UTC"),
    amount: "150",
    checking_account_id: nil}

  @transaction_2 %{
    description: "Went out for drinks",
    date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "-150",
    checking_account_id: nil}

  @transaction_3 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-19 20:00:00.000000Z], "Etc/UTC"),
    amount: "200.50",
    checking_account_id: nil}

  @transaction_4 %{
    description: "Bought books on Amazon",
    date: DateTime.from_naive!(~N[2010-04-18 14:00:00.000000Z], "Etc/UTC"),
    amount: "-150.0",
    checking_account_id: nil}

  @transaction_5 %{
    description: "payment from Jose",
    date: DateTime.from_naive!(~N[2010-03-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "302.0",
    checking_account_id: nil}

  @transaction_6 %{
    description: "payment from Ana",
    date: DateTime.from_naive!(~N[2010-04-17 23:59:00.000000Z], "Etc/UTC"),
    amount: "213.50",
    checking_account_id: nil}


  @transactions [@transaction_1, @transaction_2, @transaction_3, @transaction_4, @transaction_5, @transaction_6]

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, account} = Bank.create_checking_account(@account)
    @transactions
    |> Enum.map(&(Bank.create_transaction(%{&1 | checking_account_id: account.id})))

    {:ok, conn: conn, id: account.id}
  end

  describe "statement/2" do

    test "when there is no date passed in, returns all statements by date", %{conn: conn, id: id} do
      conn = get conn, statement_path(conn, :statement, id)

      expected_response = [
        %{"2010-03-17" => [%{"description" => "payment from Jose", "amount" => "302.0", "ts" => 1268834400}], "balance" => "302.0"},
        %{"2010-04-15" => [%{"description" => "Deposit", "amount" => "150.0", "ts" => 1271340000}], "balance" => "452.0"},
        %{"2010-04-17"=> [%{"description" => "Went out for drinks", "amount" => "-150.0", "ts" => 1271512800},
                        %{"description" => "payment from Ana","amount" => "213.50", "ts" => 1271548740}], "balance" => "515.5"},
        %{"2010-04-18" => [%{"description" => "Bought books on Amazon", "amount" => "-150.0", "ts" => 1271599200}], "balance" => "365.5"},
        %{"2010-04-19" => [%{"description" => "Deposit" ,"amount" => "200.50" ,"ts" => 1271707200}], "balance" => "566"}]


      assert json_response(conn, 200)["data"] == expected_response
    end

    test "when there are dates passed in, returns statements by date", %{conn: conn, id: id} do
      params = %{"start_date" => "2010-04-15", "end_date" => "2010-04-18"}
      conn = get conn, statement_path(conn, :statement, id, params)

      expected_response = %{
        "2010-04-15" => [%{"description" => "Deposit", "amount" => "150.0", "ts" => 1271340000}],
        "2010-04-17"=> [%{"description" => "Went out for drinks", "amount" => "-150.0", "ts" => 1271512800},
                        %{"description" => "payment from Ana", "amount" => "213.50", "ts" => 1271548740}],
        "2010-04-18" => [%{"description" => "Bought books on Amazon", "amount" => "-150.0", "ts" => 1271599200}]}


      assert json_response(conn, 200)["data"] == expected_response
    end

    test "when there is no account", %{conn: conn, id: _id} do
      conn = get conn, statement_path(conn, :statement, 99)
      not_found_json = %{"type" => "NotFound", "message" => "Account does not exist"}

      assert json_response(conn, 404)["error"] == not_found_json
    end
  end
end

