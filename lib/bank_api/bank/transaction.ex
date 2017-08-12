defmodule BankApi.Bank.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias BankApi.Bank.Transaction


  schema "transactions" do
    field :amount, :decimal
    field :date, :utc_datetime
    field :description, :string
    field :checking_account_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :date, :description, :checking_account_id])
    |> validate_required([:amount, :date, :description, :checking_account_id])
  end
end
