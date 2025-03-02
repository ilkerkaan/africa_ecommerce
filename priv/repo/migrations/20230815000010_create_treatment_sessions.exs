defmodule Dukkadee.Repo.Migrations.CreateTreatmentSessions do
  use Ecto.Migration

  def change do
    create table(:treatment_sessions) do
      add :session_number, :integer, null: false
      add :scheduled_at, :utc_datetime
      add :completed_at, :utc_datetime
      add :before_photo, :string
      add :after_photo, :string
      add :notes, :text
      add :next_appointment, :utc_datetime
      add :next_appointment_id, :integer
      add :technician_name, :string
      add :session_duration_minutes, :integer
      add :treatment_id, references(:treatments, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:treatment_sessions, [:treatment_id])
    create unique_index(:treatment_sessions, [:treatment_id, :session_number])
  end
end
