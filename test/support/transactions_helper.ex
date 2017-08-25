defmodule BankApi.TransactionsHelper do
  alias BankApi.Bank

  @account %{name: "Jhon Snow"}
  @transaction_1 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-15 14:00:00.000000Z], "Etc/UTC"),
    amount: "150",
    checking_account_id: nil}

  @transaction_2 %{
    description: "Went out for drinks",
    date: DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "-150",
    checking_account_id: nil}

  @transaction_3 %{
    description: "Deposit",
    date: DateTime.from_naive!(~N[2010-04-19 20:00:00.000000Z], "Etc/UTC"),
    amount: "200.50",
    checking_account_id: nil}

  @transaction_4 %{
    description: "Bought books on Amazon",
    date: DateTime.from_naive!(~N[2010-04-18 14:00:00.000000Z], "Etc/UTC"),
    amount: "-150.0",
    checking_account_id: nil}

  @transaction_5 %{
    description: "payment from Jose",
    date: DateTime.from_naive!(~N[2010-03-17 14:00:00.000000Z], "Etc/UTC"),
    amount: "302.0",
    checking_account_id: nil}

  @transaction_6 %{
    description: "payment from Ana",
    date: DateTime.from_naive!(~N[2010-04-17 23:59:00.000000Z], "Etc/UTC"),
    amount: "213.50",
    checking_account_id: nil}


  @transactions [@transaction_1, @transaction_2, @transaction_3, @transaction_4, @transaction_5, @transaction_6]

  def create_transactions(account_id) do
    @transactions
    |> Enum.map(&(Bank.create_transaction(%{&1 | checking_account_id: account_id})))
  end
end
