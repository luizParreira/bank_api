defmodule BankApi.DebtStatementTest do
  use BankApi.DataCase

  alias BankApi.Bank
  alias Bank.DebtStatement
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
    %{"principal" => 1185.99, "start" => "2010-04-13", "end" => "2010-04-14"},
    %{"principal" => 1035.99, "start" => "2010-04-15", "end" => "2010-04-16"},
    %{"principal" =>  972.49, "start" => "2010-04-17", "end" => "2010-04-17"},
    %{"principal" => 1122.49, "start" => "2010-04-18", "end" => "2010-04-18"},
    %{"principal" =>  921.99, "start" => "2010-04-19", "end" => "2010-04-19"}
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
      user_debt = DebtStatement.build(id)

      assert @expected_response == user_debt
    end

    test "when the user is currently in debt", %{id: id} do
      attrs = %{
        date: DateTime.from_naive!(~N[2010-04-21 17:00:00.000000Z], "Etc/UTC"),
        amount: "-100.0",
        checking_account_id: id,
        description: "went out for dinner"}

      {:ok, _transaction} = Bank.create_transaction(attrs)

      response = @expected_response ++ [
        %{"principal" =>  21.99, "start" => "2010-04-21", "end" => nil}
      ]

      assert response == DebtStatement.build(id)
    end
  end
end

