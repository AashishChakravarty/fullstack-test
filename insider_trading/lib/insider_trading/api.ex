defmodule InsiderTrading.API do
  @moduledoc """
  The Api module for call external api.
  """

  require Logger

  @company_url "https://www.sec.gov/files/company_tickers_exchange.json"
  @transaction_url "https://query2.finance.yahoo.com/v10/finance/quoteSummary/?symbol=%s&modules=insiderTransactions,summaryDetail"

  @company_api_headers [{"User-Agent", "trading/0.1.0"}, {"Accept", "*/*"}]

  defp get(url, headers \\ [], options \\ []) do
    options = [imeout: :infinity, recv_timeout: :infinity] ++ options
    HTTPoison.get(url, headers, options)
  end

  def get_companies() do
    @company_url
    |> get(@company_api_headers)
    |> handle_response()
  end

  def get_transactions(cik) do
    @transaction_url
    |> String.replace("%s", to_string(cik))
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Logger.info("Successfully Fetched")
    {:ok, body |> Jason.decode!(keys: :atoms)}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 404}}) do
    Logger.error("Not found")
    {:error, "Not found"}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    Logger.error(inspect(reason))
    {:error, reason}
  end

  defp handle_response(result) do
    Logger.error(inspect(result))
    {:error, "Something Went Wrong."}
  end
end
