defmodule BankApi.Repo.Migrations.CreateCheckingAccounts do
  use Ecto.Migration

  def change do
    create table(:checking_accounts) do
      add :name, :string

      timestamps()
    end
  end
end
