defmodule Dukkadee.Repo.Migrations.CreateCustomerTokens do
  use Ecto.Migration

  def change do
    create table(:customer_tokens) do
      add :customer_id, references(:customers, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:customer_tokens, [:customer_id])
    create unique_index(:customer_tokens, [:context, :token])
  end
end
