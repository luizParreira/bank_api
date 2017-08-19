defmodule BankApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal
      add :date, :utc_datetime
      add :description, :string

      timestamps()
    end

    create index(:transactions, [:date]) #Adding index to date since we will be querying with it later
  end
end
