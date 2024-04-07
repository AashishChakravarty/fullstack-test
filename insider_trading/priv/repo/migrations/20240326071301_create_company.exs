defmodule InsiderTrading.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:company) do
      add :name, :string
      add :cik, :integer
      add :ticker, :string
      add :exchange, :string
      add :market_cap, :decimal

      timestamps()
    end

    create index(:company, :cik)
    create index(:company, :name)
    create index(:company, :ticker)
  end
end
