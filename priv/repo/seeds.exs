# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankApi.Repo.insert!(%BankApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#
#
alias BankApi.Bank
alias BankApi.Repo

BankApi.Repo.transaction(fn ->
  {:ok, account} = Repo.insert!(:checking_accounts, name: "Account")
  {:ok, account1} = Repo.insert!(:checking_accounts, name: "Account 1")
  _ = Bank.create_checking_account(%{name: "Account 2"})
  _ = Bank.create_checking_account(%{name: "Account 3"})

  descriptions = ["Deposit", "Buy books", "Deposit", "Buy food", "buy drinks", "Payment from Joe"]
  amounts = [324.3, -223.5, 300.0, -234.5, -77.34, 400.0]
  dates = [
    DateTime.from_naive!(~N[2016-03-24 13:26:08.003], "Etc/UTC"),
    DateTime.from_naive!(~N[2016-04-29 13:26:08.003], "Etc/UTC"),
    DateTime.from_naive!(~N[2016-06-24 13:26:08.003], "Etc/UTC"),
    DateTime.from_naive!(~N[2016-11-24 13:26:08.003], "Etc/UTC"),
    DateTime.from_naive!(~N[2017-06-10 13:26:08.003], "Etc/UTC"),
    DateTime.from_naive!(~N[2017-08-12 13:26:08.003], "Etc/UTC")
  ]
  0..5
  |> Enum.map(fn index ->
    Repo.insert!(:transactions,
      checking_account_id: account.id,
      date: Enum.at(dates, index),
      amount: Enum.at(amounts, index),
      description: Enum.at(descriptions, index))
  end)

  BankApi.TransactionsHelper.create_transactions(account1.id)
end)
