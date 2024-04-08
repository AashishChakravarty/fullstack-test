defmodule InsiderTradingWeb.CompanyJSON do
  alias InsiderTrading.Accounts.Company
  alias InsiderTrading.Trading.Transaction

  @doc """
  Renders a list of company.
  """
  def index(%{company: company, count: count}) do
    %{data: for(company <- company, do: data(company)), count: count}
  end

  @doc """
  Renders a list of company transactions.
  """
  def show(%{transactions: transactions, count: count}) do
    %{data: for(transaction <- transactions, do: data(transaction)), count: count}
  end

  defp data(%Company{} = company) do
    %{
      id: company.id,
      name: company.name,
      cik: company.cik,
      ticker: company.ticker,
      exchange: company.exchange,
      market_cap: company.market_cap
    }
  end

  defp data(%Transaction{} = transaction) do
    %{
      id: transaction.id,
      name: transaction.name,
      job_title: transaction.job_title,
      start_date: transaction.start_date,
      shares: transaction.shares,
      amount: transaction.amount,
      market_cap_percentage: transaction.market_cap_percentage
    }
  end
end
