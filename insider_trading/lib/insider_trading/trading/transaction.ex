defmodule InsiderTrading.Trading.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(name job_title start_date shares amount company_id transaction_id)a
  @optional ~w(market_cap_percentage)a

  @only @required ++ @optional

  schema "transactions" do
    field :name, :string
    field :job_title, :string
    field :start_date, :date
    field :shares, :decimal
    field :amount, :decimal
    field :market_cap_percentage, :float
    field :transaction_id, :string

    belongs_to(:company, InsiderTrading.Accounts.Company)

    timestamps(type: :utc_datetime)

  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @only)
    |> validate_required(@required)
  end
end
