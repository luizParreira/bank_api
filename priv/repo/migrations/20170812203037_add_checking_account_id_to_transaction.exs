defmodule BankApi.Repo.Migrations.AddCheckingAccountIdToTransaction do
  use Ecto.Migration

  def change do

    alter table(:transactions) do
      add :checking_account_id, references(:checking_accounts)
    end
  end
end
