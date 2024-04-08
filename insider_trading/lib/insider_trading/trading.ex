defmodule InsiderTrading.Trading do
  @moduledoc """
  The Trading context.
  """

  import Ecto.Query, warn: false
  import InsiderTrading.Helpers.Common

  alias InsiderTrading.Repo

  alias InsiderTrading.Trading.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions do
    Repo.all(Transaction)
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end

  def filter_transaction_by_search(search) do
    if String.trim(search) == "" do
      true
    else
      dynamic(
        [transaction],
        ilike(
          fragment(
            "CONCAT((?), ' ',(?), ' ',(?), ' ',(?), ' ',(?))",
            transaction.name,
            transaction.job_title,
            transaction.start_date,
            transaction.shares,
            transaction.amount
          ),
          ^"%#{String.trim(search)}%"
        )
      )
    end
  end

  def get_transactions_by_company_id(company_id, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    limit = Map.get(params, "limit", "10") |> String.to_integer()
    search = Map.get(params, "search", "")
    sortby = Map.get(params, "sortby", "id")
    direction = Map.get(params, "direction", "asc")

    search_string = filter_transaction_by_search(search)

    query =
      from(transaction in Transaction,
        where: transaction.company_id == ^company_id
      )

    query =
      query
      |> where(^search_string)

    data_query =
      query
      |> add_order_by(sortby, direction)
      |> add_offset_query(page, limit)
      |> add_limit_query(limit)

    count_query =
      query
      |> select([transaction], count(transaction.id))

    data = Repo.all(data_query)
    count = Repo.one(count_query)

    {data, count}
  end
end
