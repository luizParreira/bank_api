defmodule BankApi.Bank do
  @moduledoc """
  The Bank context.
  """

  import Ecto.Query, warn: false
  alias BankApi.Repo
  alias BankApi.Bank.Transaction

  @doc """
  Function responsible for creating a transaction on the DB
  """
  def transact(id, amount, date, desc) do
    case create_transaction(%{checking_account_id: id, amount: amount, description: desc, date: date}) do
      {:ok, transaction} -> transaction
      {:error, error} -> error
    end
  end

  def list_transactions do
    Repo.all(Transaction)
  end

  def list_transactions(checking_account_id) do
    Repo.all(from t in Transaction,
             where: t.checking_account_id == ^checking_account_id,
             order_by: [asc: t.date])
  end


  def list_transactions(checking_account_id, nil), do: list_transactions(checking_account_id)
  def list_transactions(checking_account_id, date) do
    Repo.all(from t in Transaction,
             where: t.checking_account_id == ^checking_account_id and
             t.date <= ^date,
             order_by: [asc: t.date])
  end


  def list_transactions(checking_account_id, nil, nil), do: list_transactions(checking_account_id)
  def list_transactions(checking_account_id, start_date, end_date) do
    Repo.all(from t in Transaction,
             where: t.checking_account_id == ^checking_account_id and
             t.date >= ^start_date and
             t.date <= ^end_date,
             order_by: [asc: t.date])
  end

  def calculate_balance(checking_account_id, date \\ nil) do
    checking_account_id
    |> list_transactions(date)
    |> Enum.map(&(&1.amount))
    |> Enum.reduce(Decimal.new(0), &Decimal.add/2)
    |> Decimal.to_float
  end

  def get_transaction!(id), do: Repo.get!(Transaction, id)

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  alias BankApi.Bank.CheckingAccount

  def list_checking_accounts do
    Repo.all(CheckingAccount)
  end

  def get_checking_account!(id), do: Repo.get!(CheckingAccount, id)
  def get_checking_account(id), do: Repo.get(CheckingAccount, id)

  def create_checking_account(attrs \\ %{}) do
    %CheckingAccount{}
    |> CheckingAccount.changeset(attrs)
    |> Repo.insert()
  end

  def change_checking_account(%CheckingAccount{} = checking_account) do
    CheckingAccount.changeset(checking_account, %{})
  end
end
