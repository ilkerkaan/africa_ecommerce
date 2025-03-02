defmodule Dukkadee.Repo.Migrations.CreateGiftCertificates do
  use Ecto.Migration

  def change do
    create table(:gift_certificates) do
      add :code, :string, null: false
      add :amount, :decimal, null: false
      add :currency, :string, null: false
      add :recipient_name, :string, null: false
      add :recipient_email, :string, null: false
      add :sender_name, :string, null: false
      add :sender_email, :string, null: false
      add :message, :text
      add :status, :string, default: "active"
      add :issued_at, :utc_datetime
      add :expires_at, :utc_datetime
      add :redeemed_at, :utc_datetime
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:gift_certificates, [:store_id])
    create index(:gift_certificates, [:status])
    create unique_index(:gift_certificates, [:code])
  end
end
