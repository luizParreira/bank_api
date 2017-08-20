defmodule BankApi.BuildStatementTest do
  use BankApi.DataCase

  alias BankApi.Bank
  alias Bank.BuildStatement
  alias BankApi.TransactionsHelper

  setup do
    {:ok, account} = Bank.create_checking_account(%{name: "Jhon snow"})
    TransactionsHelper.create_transactions(account.id)
    {:ok, id: account.id}
  end

  describe "build_statement/3" do

    test "when no date is passed in", %{id: id} do
      statement = BuildStatement.build(id)

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

        assert statement == expected_response
    end

    test "when start date and end date is passed in", %{id: id} do
      {:ok, start_date} = DateTime.from_naive(~N[2010-04-15 00:00:00], "Etc/UTC")
      {:ok, end_date} = DateTime.from_naive(~N[2010-04-18 23:59:59], "Etc/UTC")
      statement = BuildStatement.build(id, start_date, end_date)

      expected_response = [
        %{"transactions" => [%{"description" => "Deposit", "amount" => 150.0, "ts" => 1271340000}],
          "date" => "2010-04-15",  "balance" => 452.0},
        %{"transactions"=> [%{"description" => "Went out for drinks", "amount" => -150.0, "ts" => 1271512800},
                            %{"description" => "payment from Ana","amount" => 213.5, "ts" => 1271548740}],
          "date" => "2010-04-17", "balance" => 515.5},
        %{"transactions" => [%{"description" => "Bought books on Amazon", "amount" => -150.0, "ts" => 1271599200}],
          "date" => "2010-04-18", "balance" => 365.5}]

      assert statement == expected_response
    end
  end
end

