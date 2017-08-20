defmodule BankApi.BuildDebtTest do
  use BankApi.DataCase

  alias BankApi.Bank
  alias Bank.BuildDebt
  alias BankApi.TransactionsHelper

  @transaction_1 %{
    description: "Bought books on Amazon",
    date: DateTime.from_naive!(~N[2010-03-25 14:00:00.000000Z], "Etc/UTC"),
    amount: "-550.0",
    checking_account_id: nil}

  @transaction_2 %{
    description: "payment from Jose",
    date: DateTime.from_naive!(~N[2010-03-25 20:00:00.000000Z], "Etc/UTC"),
    amount: "302.0",
    checking_account_id: nil}

  @transaction_3 %{
    description: "bought a laptop",
    date: DateTime.from_naive!(~N[2010-04-13 17:00:00.000000Z], "Etc/UTC"),
    amount: "-1239.99",
    checking_account_id: nil}

  @transaction_4 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-20 20:00:00.000000Z], "Etc/UTC"),
    amount: "1000.0",
    checking_account_id: nil}

  @expected_response [
    %{"principal" =>  248.0, "start" => 1269525600, "end" => 1269547200},
    %{"principal" => 1185.99, "start" => 1271178000, "end" => 1271340000},
    %{"principal" => 1035.99, "start" => 1271340000, "end" => 1271512800},
    %{"principal" => 1185.99, "start" => 1271512800, "end" => 1271548740},
    %{"principal" =>  972.49, "start" => 1271548740, "end" => 1271599200},
    %{"principal" => 1122.49, "start" => 1271599200, "end" => 1271707200},
    %{"principal" =>  921.99, "start" => 1271707200, "end" => 1271793600}
  ]

  @transactions [@transaction_1, @transaction_2, @transaction_3, @transaction_4]

  setup do
    {:ok, account} = Bank.create_checking_account(%{name: "Jhon snow"})
    TransactionsHelper.create_transactions(account.id)

    @transactions
    |> Enum.map(&(Bank.create_transaction(%{&1 | checking_account_id: account.id})))

    {:ok, id: account.id}
  end

  describe "build/1" do

    test "when the user is not currently in debt", %{id: id} do
      user_debt = BuildDebt.build(id)

      IO.inspect user_debt

      assert @expected_response == user_debt
    end

    test "when the user is currently in debt", %{id: id} do
      attrs = %{
        date: DateTime.from_naive!(~N[2010-04-21 17:00:00.000000Z], "Etc/UTC"),
        amount: "-100.0",
        checking_account_id: id,
        description: "went out for dinner"}

      {:ok, transaction} = Bank.create_transaction(attrs)

      response = @expected_response ++ [
        %{"principal" =>  21.99, "start" => 1271869200, "end" => nil}
      ]

      assert response == BuildDebt.build(id)
    end
  end
end

