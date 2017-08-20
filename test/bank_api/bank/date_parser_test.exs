defmodule BankApi.DateParserTest do
  use BankApi.DataCase
  alias BankApi.Bank.DateParser

  describe "start_of_day/1" do
    test "when date is a string" do
      {:ok, date} = DateParser.start_of_day("2010-04-15")

      assert date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
    end

    test "when date is datetime" do
      datetime = DateTime.from_naive!(~N[2010-04-15 20:00:00], "Etc/UTC")
      {:ok, date} = DateParser.start_of_day(datetime)

      assert date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
    end

    test "when date is a timestamp" do
      {:ok, date} = DateParser.start_of_day(1271361600)

      assert date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
    end

    test "when date is not valid" do
      assert DateParser.start_of_day("2010/04/15") == :error
    end
  end

  describe "start_of_day!/1" do
    test "when date is a string" do
      date = DateParser.start_of_day!("2010-04-15")

      assert date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
    end

    test "when date is datetime" do
      datetime = DateTime.from_naive!(~N[2010-04-15 20:00:00], "Etc/UTC")
      date = DateParser.start_of_day!(datetime)

      assert date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
    end

    test "when date is a timestamp" do
      date = DateParser.start_of_day!(1271361600)

      assert date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
    end

    test "when date is not valid" do
      assert DateParser.start_of_day("2010/04/15") == :error
    end
  end

  describe "end_of_day/1" do
    test "when date is a string" do
      {:ok, date} = DateParser.end_of_day("2010-04-18")

      assert date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when date is datetime" do
      datetime = DateTime.from_naive!(~N[2010-04-18 20:00:00], "Etc/UTC")
      {:ok, date} = DateParser.end_of_day(datetime)

      assert date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when date is a timestamp" do
      {:ok, date} = DateParser.end_of_day(1271620800)

      assert date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when date is not valid" do
      assert DateParser.end_of_day("2010/04/15") == :error
    end
  end

  describe "end_of_day!/1" do
    test "when date is a string" do
      date = DateParser.end_of_day!("2010-04-18")

      assert date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when date is datetime" do
      datetime = DateTime.from_naive!(~N[2010-04-18 20:00:00], "Etc/UTC")
      date = DateParser.end_of_day!(datetime)

      assert date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when date is a timestamp" do
      date = DateParser.end_of_day!(1271620800)

      assert date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when date is not valid" do
      assert DateParser.end_of_day!("2010/04/15") == :error
    end
  end

  describe "parse/2" do
    test "when start date and end date is nil" do
      assert DateParser.parse(start_of: nil, end_of: nil) == {:ok, nil, nil}
    end

    test "when is a valid date" do
      {:ok, start_date, end_date} = DateParser.parse(start_of: "2010-04-15", end_of: "2010-04-18")

      assert start_date == DateTime.from_naive!(~N[2010-04-15 00:00:00], "Etc/UTC")
      assert end_date == DateTime.from_naive!(~N[2010-04-18 23:59:59], "Etc/UTC")
    end

    test "when is an invalid date" do
      response = DateParser.parse(start_of: "2010/04/15", end_of: "2010/04/18")

      assert response == :error
    end
  end
end

