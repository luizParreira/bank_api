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
