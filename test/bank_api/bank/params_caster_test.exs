defmodule BankApi.ParamsCasterTest do
  use BankApi.DataCase

  alias BankApi.Bank.ParamsCaster

  describe "cast/2" do
    @params %{
      amount: "120.5",
      date: 1271512800,
      description: "some description",
      checking_account_id: 1234}

    test "when date is a string timestamp" do
      cast_params = ParamsCaster.cast(@params)

      assert cast_params.date == DateTime.from_naive!(~N[2010-04-17 14:00:00Z], "Etc/UTC")
    end

    test "when date is a string" do
      cast_params = ParamsCaster.cast(%{@params | date: ~N[2010-04-17 14:00:00Z]})

      assert cast_params.date == ~N[2010-04-17 14:00:00Z]
    end

    test "when amount is negative" do
      cast_params = ParamsCaster.cast(%{@params | amount: "-120.5"})

      assert cast_params.amount == nil
    end

    test "when parsing transaction" do
      cast_params = ParamsCaster.cast(@params)

      assert cast_params.amount == 120.5
      assert cast_params.date == DateTime.from_naive!(~N[2010-04-17 14:00:00Z], "Etc/UTC")
      assert cast_params.description == "some description"
      assert cast_params.checking_account_id == 1234
    end

    test "when trying to cast an unexpected map" do
      assert ParamsCaster.cast(%{name: "anoter unexpected map"}) == %{}
    end
  end
end

