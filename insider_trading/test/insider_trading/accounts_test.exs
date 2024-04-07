defmodule InsiderTrading.AccountsTest do
  use InsiderTrading.DataCase

  alias InsiderTrading.Accounts

  describe "company" do
    alias InsiderTrading.Accounts.Company

    import InsiderTrading.AccountsFixtures

    @invalid_attrs %{name: nil, exchange: nil, ticker: nil, cik: nil, market_cap: nil}

    test "list_company/0 returns all company" do
      company = company_fixture()
      assert Accounts.list_company() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Accounts.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      valid_attrs = %{name: "some name", exchange: "some exchange", ticker: "some ticker", cik: 42, market_cap: "2T"}

      assert {:ok, %Company{} = company} = Accounts.create_company(valid_attrs)
      assert company.name == "some name"
      assert company.exchange == "some exchange"
      assert company.ticker == "some ticker"
      assert company.cik == 42
      assert company.market_cap == "2T"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      update_attrs = %{name: "some updated name", exchange: "some updated exchange", ticker: "some updated ticker", cik: 43, market_cap: "2.2T"}

      assert {:ok, %Company{} = company} = Accounts.update_company(company, update_attrs)
      assert company.name == "some updated name"
      assert company.exchange == "some updated exchange"
      assert company.ticker == "some updated ticker"
      assert company.cik == 43
      assert company.market_cap == "2.2T"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_company(company, @invalid_attrs)
      assert company == Accounts.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Accounts.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Accounts.change_company(company)
    end
  end
end
