defmodule BankApi.Bank.DateParser do
  @moduledoc """
  Module responsible for parsing the API input from `2017-08-20` to `DateTime` object,
  where `start_date` will be starting at the begining of the day, and `end_date`
  at the last second of the day.
  """

  def start_of_day!(date), do: with {:ok, date} <- start_of_day(date), do: date

  @doc "when date is a `string` '2017-08-20'"
  def start_of_day(date) when is_bitstring(date) do
    with {:ok, date} <- Date.from_iso8601(date),
         {:ok, date} <- NaiveDateTime.new(date, ~T[00:00:00]),
         {:ok, date} <- DateTime.from_naive(date, "Etc/UTC")
    do
      {:ok, date}
    else
      _ -> :error
    end
  end

  @doc "when date is a `timestamp` integer"
  def start_of_day(date) when is_integer(date) do
    with  {:ok, date} <- DateTime.from_unix(date),
          date <- DateTime.to_date(date),
         {:ok, date} <- NaiveDateTime.new(date, ~T[00:00:00]),
         {:ok, date} <- DateTime.from_naive(date, "Etc/UTC")
    do
      {:ok, date}
    else
      _ -> :error
    end
  end

  @doc "when date is a `datetime` struct"
  def start_of_day(date) do
    with  date <- DateTime.to_date(date),
         {:ok, date} <- NaiveDateTime.new(date, ~T[00:00:00]),
         {:ok, date} <- DateTime.from_naive(date, "Etc/UTC")
    do
      {:ok, date}
    else
      _ -> :error
    end
  end

  def end_of_day!(date), do: with {:ok, date} <- end_of_day(date), do: date

  @doc "when date is a `string` '2017-08-20'"
  def end_of_day(date) when is_bitstring(date) do
    with {:ok, date} <- Date.from_iso8601(date),
         {:ok, date} <- NaiveDateTime.new(date, ~T[23:59:59]),
         {:ok, date}  <- DateTime.from_naive(date, "Etc/UTC")
    do
      {:ok, date}
    else
      _ -> :error
    end
  end

  @doc "when date is a `timestamp` integer"
  def end_of_day(date) when is_integer(date) do
    with  {:ok, date} <- DateTime.from_unix(date),
          date <- DateTime.to_date(date),
         {:ok, date} <- NaiveDateTime.new(date, ~T[23:59:59]),
         {:ok, date}  <- DateTime.from_naive(date, "Etc/UTC")
    do
      {:ok, date}
    else
      _ -> :error
    end
  end

  @doc "when date is a `datetime` struct"
  def end_of_day(date) do
    with  date <- DateTime.to_date(date),
         {:ok, date} <- NaiveDateTime.new(date, ~T[23:59:59]),
         {:ok, date}  <- DateTime.from_naive(date, "Etc/UTC")
    do
      {:ok, date}
    else
      _ -> :error
    end
  end

  def parse(start_of: nil, end_of: nil), do: {:ok, nil, nil}
  def parse(opts) do
    with {:ok, start_date} <- start_of_day(opts[:start_of]),
         {:ok, end_date} <- end_of_day(opts[:end_of])
    do
      {:ok, start_date, end_date}
    else
      _ -> :error
    end
  end
end
