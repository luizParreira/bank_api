defmodule BankApi.Web.BalanceControllerTest do
  use BankApi.Web.ConnCase

  alias BankApi.Bank

  @account %{name: "Jhon Snow"}
  @transaction_1 %{
    description: "some description",
    date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "150",
    checking_account_id: nil}

  @transaction_2 %{
    description: "some description",
    date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "-150",
    checking_account_id: nil}

  @transaction_3 %{
    description: "some description",
    date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "200.50",
    checking_account_id: nil}

  @transactions [@transaction_1, @transaction_2, @transaction_3]

  setup %{conn: conn} do
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, account} = Bank.create_checking_account(@account)
    @transactions
    |> Enum.map(&(Bank.create_transaction(%{&1 | checking_account_id: account.id})))

    {:ok, conn: conn, id: account.id}
  end

  describe "balance/2" do
    test "when balance is positive", %{conn: conn, id: id} do
      conn = get conn, balance_path(conn, :balance, id)

      assert json_response(conn, 200)["data"] == %{"balance" => 200.5}
    end

    test "when balance is negative", %{conn: conn, id: id} do
      extra_transaction =  %{
        description: "some description",
        date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
        amount: "-300",
        checking_account_id: id}
      Bank.create_transaction(extra_transaction)
      conn = get conn, balance_path(conn, :balance, id)

      assert json_response(conn, 200)["data"] == %{"balance" => -99.5}
    end

    test "when account does not exist", %{conn: conn, id: _id} do
      conn = get conn, balance_path(conn, :balance, 99)
      not_found_json = %{"type" => "NotFound", "message" => "Account does not exist"}

      assert json_response(conn, 404)["error"] == not_found_json
    end
  end
end

