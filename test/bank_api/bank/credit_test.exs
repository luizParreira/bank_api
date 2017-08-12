
defmodule BankApi.CreditTest do
  use BankApi.DataCase

  alias BankApi.Bank.Credit
  alias BankApi.Bank

  describe "credit/1" do
    alias BankApi.Bank.Transaction

    @valid_attrs %{
      amount: "120.5",
      date: 1271512800,
      description: "some description",
      checking_account_id: nil}

    @invalid_attrs %{amount: nil, date: nil, description: nil, checking_account_id: nil}

    setup do
      {:ok, account} = Bank.create_checking_account(%{name: "some name"})
      {:ok, %{params: %{ @valid_attrs | checking_account_id: account.id }}}
    end

    test "with valid data creates credit transaction", %{params: params} do
      assert {:ok, %Transaction{} = transaction} = Credit.credit(params)
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.date == DateTime.from_naive!(~N[2010-04-17 14:00:00Z], "Etc/UTC")
      assert transaction.description == "some description"
    end

    test "trying to credit a negative amount of the user's account", %{params: params} do
      assert {:error, %Ecto.Changeset{}} = Credit.credit(%{params | amount: "-100.0" })
    end

    test "credit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Credit.credit(@invalid_attrs)
    end
  end
end
