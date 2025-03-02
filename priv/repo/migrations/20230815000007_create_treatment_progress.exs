defmodule Dukkadee.Repo.Migrations.CreateTreatmentProgress do
  use Ecto.Migration

  def change do
    create table(:treatment_progress) do
      add :customer_id, references(:customers, on_delete: :delete_all), null: false
      add :treatment_area, :string, null: false
      add :start_date, :date, null: false
      add :current_session, :integer, default: 1
      add :total_sessions, :integer
      add :completion_percentage, :integer
      add :initial_photo, :string
      add :current_photo, :string
      add :next_appointment_date, :utc_datetime
      add :notes, :string
      add :status, :string, default: "active"
      add :product_id, references(:products, on_delete: :nilify_all)

      timestamps()
    end

    create index(:treatment_progress, [:customer_id])
    create index(:treatment_progress, [:product_id])
    create index(:treatment_progress, [:status])
  end
end
