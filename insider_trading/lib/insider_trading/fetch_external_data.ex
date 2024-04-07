defmodule InsiderTrading.FetchExternalData do
  @moduledoc """
  The FetchExternalData module for Fetch external data.
  """

  import InsiderTrading.Helpers.Common

  alias InsiderTrading.Repo
  alias InsiderTrading.API
  alias InsiderTrading.Accounts
  alias InsiderTrading.Trading.Transaction

  def run(company_limit \\ 20) do
    fetch_companies()
    fetch_transactions(company_limit)
  end

  def fetch_companies() do
    API.get_companies()
    |> handle_response()
    |> persist_data()
  end

  def fetch_transactions(limit \\ 20) do
    Accounts.get_companies(limit)
    |> Stream.map(&{API.get_transactions(&1.ticker), &1.ticker})
    |> Stream.map(&{handle_response(elem(&1, 0)), elem(&1, 1)})
    |> Stream.reject(&is_nil(elem(&1, 0)))
    |> Task.async_stream(&prepare_data/1, max_concurrency: 10, ordered: false)
    |> Stream.map(fn {_, data} -> data end)
    |> Stream.map(&create_transaction_multi_transaction/1)
    |> Task.async_stream(&Repo.transaction/1, max_concurrency: 10, ordered: false)
    |> Stream.run()
  end

  defp handle_response(
         {:ok,
          %{
            quoteSummary: %{
              result: nil
            }
          }}
       ),
       do: nil

  defp handle_response(
         {:ok,
          %{
            quoteSummary: %{
              result: data
            }
          }}
       ),
       do: data

  defp handle_response({:ok, data}), do: data

  defp handle_response(_), do: nil

  def persist_data(records) do
    data = records.data

    data
    |> Stream.map(&build_company_changeset/1)
    |> Task.async_stream(&Repo.transaction/1, max_concurrency: 50, ordered: false)
    |> Stream.run()
  end

  def build_company_changeset([cik, name, ticker, exchange]) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:create_company, fn _, _ ->
      %{
        name: name,
        exchange: exchange,
        ticker: ticker,
        cik: cik
      }
      |> Accounts.upsert_company()
    end)
  end

  def prepare_data({data, ticker}) do
    data = List.first(data)
    transactions = get_in(data, [:insiderTransactions, :transactions]) || []

    market_cap = get_in(data, [:summaryDetail, :marketCap, :raw])

    transactions =
      Stream.map(transactions, fn transaction ->
        name = transaction.filerName
        job_title = transaction.filerRelation
        start_date_timestamp = transaction.startDate.raw
        transaction_text = transaction.transactionText
        shares = get_in(transaction, [:shares, :raw])

        transaction_id =
          "#{name} #{job_title} #{shares} #{transaction_text} #{start_date_timestamp}"
          |> text_normalizer()

        %{
          name: name,
          job_title: job_title,
          start_date: Date.from_iso8601!(transaction.startDate.fmt),
          shares: shares,
          amount: get_in(transaction, [:value, :raw]),
          market_cap_percentage: calculate_market_cap_percentage(shares, market_cap),
          transaction_id: transaction_id
        }
        |> add_timestamps()
      end)
      |> Enum.to_list()

    {transactions, market_cap, ticker}
  end

  def calculate_market_cap_percentage(_shares, nil), do: nil

  def calculate_market_cap_percentage(shares, market_cap) do
    shares / market_cap * 100
  end

  defp create_transaction_multi_transaction({transactions, market_cap, ticker}) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:get_company, fn _, _ ->
      {:ok, Accounts.get_company_by_ticker(ticker)}
    end)
    |> Ecto.Multi.run(:update_market_cap, fn _, %{get_company: company} ->
      case market_cap do
        nil ->
          {:ok, nil}

        _ ->
          Accounts.update_company(company, %{market_cap: market_cap})
      end
    end)
    |> Ecto.Multi.insert_all(
      :insert_transactions,
      Transaction,
      fn %{get_company: company} ->
        transactions
        |> Enum.map(fn transaction ->
          Map.put(transaction, :company_id, company.id)
        end)
      end,
      on_conflict: :nothing,
      conflict_target: [:transaction_id]
    )
  end
end
