defmodule InsiderTrading.Accounts.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(name exchange ticker cik)a
  @optional ~w(market_cap)a

  @only @required ++ @optional

  schema "company" do
    field :name, :string
    field :exchange, :string
    field :ticker, :string
    field :cik, :integer
    field :market_cap, :decimal

    has_many(:transactions, InsiderTrading.Trading.Transaction)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, @only)
    |> validate_required(@required)
  end
end
