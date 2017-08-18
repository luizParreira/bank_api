defmodule BankApi.DebitTest do
  use BankApi.DataCase

  alias BankApi.Bank.Debit
  alias BankApi.Bank
  alias BankApi.Bank.Transaction

  describe "debit/1" do
    @valid_attrs %{
      amount: "120.5",
      date: 1271512800,
      description: "some description",
      checking_account_id: nil}

    @invalid_attrs %{amount: nil, date: nil, description: nil, checking_account_id: nil}
    setup do
      {:ok, account} = Bank.create_checking_account(%{name: "some name"})
      {:ok, %{params: %{@valid_attrs | checking_account_id: account.id}}}
    end

    test "with valid data creates debit transaction", %{params: params} do
      assert {:ok, %Transaction{} = transaction} = Bank.debit(params)
      assert transaction.amount == Decimal.new("-120.5")
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17 14:00:00Z], "Etc/UTC")
      assert transaction.description == "some description"
    end

    test "when date is a string timestamp", %{params: params} do
      assert {:ok, %Transaction{} = transaction} = Bank.debit(%{params | date: ~N[2010-04-17 14:00:00Z]})
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17 14:00:00Z], "Etc/UTC")
    end

    test "trying to debit a negative amount of the user's account", %{params: params} do
      assert {:error, %Ecto.Changeset{}} = Bank.debit(%{params | amount: "-100.0"})
    end

    test "debit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bank.debit(@invalid_attrs)
    end
  end
end
