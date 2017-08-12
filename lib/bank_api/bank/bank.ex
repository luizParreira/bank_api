defmodule BankApi.Bank do
  @moduledoc """
  The Bank context.
  """

  import Ecto.Query, warn: false
  alias BankApi.Repo

  alias BankApi.Bank.Transaction

  defdelegate credit(params), to: BankApi.Bank.Credit

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
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

  def get_checking_account(id) do
    Repo.get(CheckingAccount, id)
    |> match_checking_account
  end

  defp match_checking_account(nil), do: {:not_found, nil}
  defp match_checking_account(account), do: {:ok, account}

  def create_checking_account(attrs \\ %{}) do
    %CheckingAccount{}
    |> CheckingAccount.changeset(attrs)
    |> Repo.insert()
  end

  def change_checking_account(%CheckingAccount{} = checking_account) do
    CheckingAccount.changeset(checking_account, %{})
  end
end
