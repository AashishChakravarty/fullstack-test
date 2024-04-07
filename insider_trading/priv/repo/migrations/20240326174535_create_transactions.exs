defmodule InsiderTrading.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :company_id, references(:company, on_delete: :nothing)
      add :name, :string
      add :job_title, :string
      add :start_date, :date
      add :shares, :decimal
      add :amount, :decimal
      add :market_cap_percentage, :float
      add :transaction_id, :string

      timestamps()
    end

    create unique_index(:transactions, [:transaction_id])

  end
end
