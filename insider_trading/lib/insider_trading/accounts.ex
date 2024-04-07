defmodule InsiderTrading.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Hex.Repo
  alias InsiderTrading.Repo

  alias InsiderTrading.Accounts.Company

  @doc """
  Returns the list of company.

  ## Examples

      iex> list_company()
      [%Company{}, ...]

  """
  def list_company do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  def get_companies(limit \\ 10) do
    from(Company,
      order_by: :id,
      limit: ^limit
    )
    |> Repo.all()
  end

  def get_company_by_cik(cik, ticker) do
    Repo.get_by(Company, cik: cik, ticker: ticker)
  end

  def get_company_by_ticker(ticker) do
    Repo.get_by(Company, ticker: ticker)
  end

  def upsert_company(attrs) do
    with %Company{} = company <- get_company_by_cik(attrs.cik, attrs.ticker) do
      update_company(company, attrs)
    else
      nil -> create_company(attrs)
    end
  end
end