defmodule Dukkadee.Repo.Migrations.CreateTreatments do
  use Ecto.Migration

  def change do
    create table(:treatments) do
      add :tattoo_name, :string, null: false
      add :package_name, :string, null: false
      add :started_at, :utc_datetime, null: false
      add :completed_at, :utc_datetime
      add :total_sessions, :integer, null: false
      add :completed_sessions, :integer, null: false, default: 0
      add :before_photo, :string
      add :current_photo, :string
      add :notes, :text
      add :next_appointment, :utc_datetime
      add :next_appointment_id, :integer
      add :customer_id, references(:customers, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:treatments, [:customer_id])
  end
end
