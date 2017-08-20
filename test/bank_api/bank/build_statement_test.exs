defmodule BankApi.BuildStatementTest do
  use BankApi.DataCase

  alias BankApi.Bank
  alias Bank.BuildStatement
  @account %{name: "Jhon Snow"}
  @transaction_1 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-15 14:00:00.000000Z], "Etc/UTC"),
    amount: "150.0",
    checking_account_id: nil}

  @transaction_2 %{
    description: "Went out for drinks",
    date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "-150.0",
    checking_account_id: nil}

  @transaction_3 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-19 20:00:00.000000Z], "Etc/UTC"),
    amount: "200.5",
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
    amount: "213.5",
    checking_account_id: nil}


  @transactions [@transaction_1, @transaction_2, @transaction_3, @transaction_4, @transaction_5, @transaction_6]

  setup do
    {:ok, account} = Bank.create_checking_account(@account)
    @transactions
    |> Enum.map(&(Bank.create_transaction(%{&1 | checking_account_id: account.id})))

    {:ok, id: account.id}
  end

  describe "build_statement/3" do

    test "when no date is passed in", %{id: id} do
      statement = BuildStatement.build(id)

      expected_response = [
        %{"2010-03-17" => [%{"description" => "payment from Jose", "amount" => 302.0, "ts" => 1268834400}], "balance" => 302.0},
        %{"2010-04-15" => [%{"description" => "Deposit", "amount" => 150.0, "ts" => 1271340000}], "balance" => 452.0},
        %{"2010-04-17"=> [%{"description" => "Went out for drinks", "amount" => -150.0, "ts" => 1271512800},
                        %{"description" => "payment from Ana","amount" => 213.5, "ts" => 1271548740}], "balance" => 515.5},
        %{"2010-04-18" => [%{"description" => "Bought books on Amazon", "amount" => -150.0, "ts" => 1271599200}], "balance" => 365.5},
        %{"2010-04-19" => [%{"description" => "Deposit" ,"amount" => 200.5,"ts" => 1271707200}], "balance" => 566.0}]

        assert statement == expected_response
    end

    test "when start date and end date is passed in", %{id: id} do
      {:ok, start_date} = Date.from_iso8601("2010-04-15")
      {:ok, end_date} = Date.from_iso8601("2010-04-18")
      statement = BuildStatement.build(id, start_date, end_date)

      expected_response = [
        %{"2010-04-15" => [%{"description" => "Deposit", "amount" => 150.0, "ts" => 1271340000}], "balance" => 452.0},
        %{"2010-04-17"=> [%{"description" => "Went out for drinks", "amount" => -150.0, "ts" => 1271512800},
                        %{"description" => "payment from Ana","amount" => 213.5, "ts" => 1271548740}], "balance" => 515.5},
        %{"2010-04-18" => [%{"description" => "Bought books on Amazon", "amount" => -150.0, "ts" => 1271599200}], "balance" => 365.5}]

      assert statement == expected_response
    end
  end
end

