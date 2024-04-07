defmodule InsiderTrading.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InsiderTrading.Accounts` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        cik: 42,
        exchange: "some exchange",
        name: "some name",
        ticker: "some ticker",
        market_cap: "2T"
      })
      |> InsiderTrading.Accounts.create_company()

    company
  end
end
