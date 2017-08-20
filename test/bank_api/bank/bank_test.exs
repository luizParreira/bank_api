defmodule BankApi.BankTest do
  use BankApi.DataCase

  alias BankApi.Bank

  describe "transactions" do
    alias BankApi.Bank.Transaction

    @valid_attrs %{
      amount: "120.5",
      date: ~N[2010-04-17 14:00:00.000000Z],
      description: "some description",
      checking_account_id: nil}

    @invalid_attrs %{amount: nil, date: nil, description: nil, checking_account_id: nil}

    setup do
      {:ok, account} = Bank.create_checking_account(%{name: "some name"})

      {:ok, attrs: %{@valid_attrs | checking_account_id: account.id}}
    end

    test "calculate_balance/1 calculates user balance", %{attrs: attr} do
      {:ok, _} = Bank.create_transaction(attr)
      {:ok, _} = Bank.create_transaction(%{attr | amount: "123.0"})

      assert Bank.calculate_balance(attr.checking_account_id) == 243.5
    end

    test "calculate_balance/2 calculates user balance given date", %{attrs: attr} do
      {:ok, _} = Bank.create_transaction(attr)
      date = ~N[2010-04-18 14:00:00Z]
      {:ok, _} = Bank.create_transaction(%{attr | amount: "-223.0", date: date})
      date1 = ~N[2010-04-19 14:00:00Z]
      {:ok, _} = Bank.create_transaction(%{attr | amount: "123.0", date: date1})

      assert Bank.calculate_balance(attr.checking_account_id, date) == -102.5
    end

    test "list_transactions/0 returns all transactions", %{attrs: attributes} do
      {:ok, transaction} = Bank.create_transaction(attributes)
      assert Bank.list_transactions() == [transaction]
    end

    test "list_transactions/1 returns all transactions for given user", %{attrs: attr} do
      {:ok, account} = Bank.create_checking_account(%{name: "some other account"})
      {:ok, transaction} = Bank.create_transaction(attr)
      {:ok, transaction1} = Bank.create_transaction(%{attr | checking_account_id: account.id})

      assert Bank.list_transactions(attr.checking_account_id) == [transaction]
      assert Bank.list_transactions(account.id) == [transaction1]
    end

    test "list_transactions/2 returns all transactions for given user until a given date", %{attrs: attr} do
      {:ok, transaction} = Bank.create_transaction(attr)
      date = ~N[2010-04-18 14:00:00Z]
      {:ok, transaction1} = Bank.create_transaction(%{attr | date: date})
      date1 = ~N[2010-04-19 14:00:00Z]
      {:ok, _transaction2}  = Bank.create_transaction(%{attr | date: date1})

      assert Enum.map(Bank.list_transactions(attr.checking_account_id, date), &(&1.id)) ==
        [transaction.id, transaction1.id]
    end

    test "list_transactions/3 returns all transactions for given user within a date range", %{attrs: attr} do
      {:ok, _transaction} = Bank.create_transaction(attr)
      date = ~N[2010-04-18 14:00:00Z]
      {:ok, transaction1} = Bank.create_transaction(%{attr | date: date})
      date1 = ~N[2010-04-19 14:00:00Z]
      {:ok, transaction2}  = Bank.create_transaction(%{attr | date: date1})
      date2 = ~N[2010-04-20 14:00:00Z]
      {:ok, transaction3} = Bank.create_transaction(%{attr | date: date2})
      date3 = ~N[2010-04-21 14:00:00Z]
      {:ok, _transaction4} = Bank.create_transaction(%{attr | date: date3})

      assert Enum.map(Bank.list_transactions(attr.checking_account_id, date, date2), &(&1.id)) ==
        [transaction1.id, transaction2.id, transaction3.id]
    end

    test "get_transaction!/1 returns the transaction with given id", %{attrs: attributes} do
      {:ok, transaction} = Bank.create_transaction(attributes)
      assert Bank.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction", %{attrs: attributes} do
      assert {:ok, %Transaction{} = transaction} = Bank.create_transaction(attributes)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert transaction.description == "some description"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_transaction(@invalid_attrs)
    end

    test "change_transaction/1 returns a transaction changeset", %{attrs: attributes} do
      {:ok, transaction} = Bank.create_transaction(attributes)
      assert %Ecto.Changeset{} = Bank.change_transaction(transaction)
    end

  end

  describe "checking_accounts" do
    alias BankApi.Bank.CheckingAccount

    @valid_attrs %{name: "some name"}
    @invalid_attrs %{name: nil}

    def checking_account_fixture(attrs \\ %{}) do
      {:ok, checking_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_checking_account()

      checking_account
    end

    test "list_checking_accounts/0 returns all checking_accounts" do
      checking_account = checking_account_fixture()
      assert Bank.list_checking_accounts() == [checking_account]
    end

    test "get_checking_account!/1 returns the checking_account with given id" do
      checking_account = checking_account_fixture()
      assert Bank.get_checking_account!(checking_account.id) == checking_account
    end

    test "create_checking_account/1 with valid data creates a checking_account" do
      assert {:ok, %CheckingAccount{} = checking_account} = Bank.create_checking_account(@valid_attrs)
      assert checking_account.name == "some name"
    end

    test "create_checking_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_checking_account(@invalid_attrs)
    end

    test "change_checking_account/1 returns a checking_account changeset" do
      checking_account = checking_account_fixture()
      assert %Ecto.Changeset{} = Bank.change_checking_account(checking_account)
    end
  end
end
