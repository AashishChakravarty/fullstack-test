defmodule InsiderTrading.TradingTest do
  use InsiderTrading.DataCase

  alias InsiderTrading.Trading

  describe "transactions" do
    alias InsiderTrading.Trading.Transaction

    import InsiderTrading.TradingFixtures

    @invalid_attrs %{name: nil, job_title: nil, start_date: nil, shares: nil, amount: nil, market_cap_percentage: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Trading.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Trading.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{name: "some name", job_title: "some job_title", start_date: "some start_date", shares: 120.5, amount: "120.5", market_cap_percentage: 120.5}

      assert {:ok, %Transaction{} = transaction} = Trading.create_transaction(valid_attrs)
      assert transaction.name == "some name"
      assert transaction.job_title == "some job_title"
      assert transaction.start_date == "some start_date"
      assert transaction.shares == 120.5
      assert transaction.amount == Decimal.new("120.5")
      assert transaction.market_cap_percentage == 120.5
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Trading.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{name: "some updated name", job_title: "some updated job_title", start_date: "some updated start_date", shares: 456.7, amount: "456.7", market_cap_percentage: 456.7}

      assert {:ok, %Transaction{} = transaction} = Trading.update_transaction(transaction, update_attrs)
      assert transaction.name == "some updated name"
      assert transaction.job_title == "some updated job_title"
      assert transaction.start_date == "some updated start_date"
      assert transaction.shares == 456.7
      assert transaction.amount == Decimal.new("456.7")
      assert transaction.market_cap_percentage == 456.7
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Trading.update_transaction(transaction, @invalid_attrs)
      assert transaction == Trading.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Trading.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Trading.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Trading.change_transaction(transaction)
    end
  end
end
