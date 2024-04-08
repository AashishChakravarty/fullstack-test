defmodule InsiderTradingWeb.CompanyController do
  use InsiderTradingWeb, :controller

  alias InsiderTrading.Accounts
  alias InsiderTrading.Trading

  action_fallback(InsiderTradingWeb.FallbackController)

  def index(conn, params) do
    {company, count} = Accounts.get_company_list(params)
    render(conn, :index, company: company, count: count)
  end

  def show(conn, %{"company_id" => company_id} = params) do
    {transactions, count} = Trading.get_transactions_by_company_id(company_id, params)
    render(conn, :show, transactions: transactions, count: count)
  end
end
