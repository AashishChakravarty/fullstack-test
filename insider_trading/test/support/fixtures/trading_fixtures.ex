defmodule InsiderTrading.TradingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InsiderTrading.Trading` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        job_title: "some job_title",
        market_cap_percentage: 120.5,
        name: "some name",
        shares: 120.5,
        start_date: "some start_date"
      })
      |> InsiderTrading.Trading.create_transaction()

    transaction
  end
end
