defmodule BankApi.AmountValidatorTest do
  use BankApi.DataCase

  alias BankApi.Bank.AmountValidator

  describe "validate/2" do

    test "when amount is a positive float" do
      {:ok, amount_credit} = AmountValidator.validate("120.0", :credit)
      {:ok, amount_debit} = AmountValidator.validate("120.0", :debit)

      assert amount_credit == 120.0
      assert amount_debit == -120.0
    end

    test "when amount is negative float" do
      amount_credit = AmountValidator.validate("-120.0", :credit)
      amount_debit = AmountValidator.validate("-120.0", :debit)

      assert amount_credit == :error
      assert amount_debit == :error
    end

    test "when amount is not a number" do
      amount_credit = AmountValidator.validate("hello", :credit)
      amount_debit = AmountValidator.validate("world", :debit)

      assert amount_credit == :error
      assert amount_debit == :error
    end
  end
end

