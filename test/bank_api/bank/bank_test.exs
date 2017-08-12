defmodule BankApi.BankTest do
  use BankApi.DataCase

  alias BankApi.Bank

  describe "transactions" do
    alias BankApi.Bank.Transaction

    @valid_attrs %{amount: "120.5", date: ~N[2010-04-17 14:00:00.000000Z], description: "some description"}
    @update_attrs %{amount: "456.7", date: ~N[2011-05-18 15:01:01.000000Z], description: "some updated description"}
    @invalid_attrs %{amount: nil, date: nil, description: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bank.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Bank.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Bank.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Bank.create_transaction(@valid_attrs)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert transaction.description == "some description"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, transaction} = Bank.update_transaction(transaction, @update_attrs)
      assert %Transaction{} = transaction
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert transaction.description == "some updated description"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Bank.update_transaction(transaction, @invalid_attrs)
      assert transaction == Bank.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Bank.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Bank.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Bank.change_transaction(transaction)
    end
  end
end
