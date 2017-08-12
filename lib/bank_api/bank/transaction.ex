defmodule BankApi.Bank.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias BankApi.Bank.Transaction


  schema "transactions" do
    field :amount, :decimal
    field :date, :utc_datetime
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(%Transaction{} = transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :date, :description])
    |> validate_required([:amount, :date, :description])
  end
end
