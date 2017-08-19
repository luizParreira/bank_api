defmodule BankApi.Bank.CheckingAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias BankApi.Bank.CheckingAccount


  schema "checking_accounts" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%CheckingAccount{} = checking_account, attrs) do
    checking_account
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
