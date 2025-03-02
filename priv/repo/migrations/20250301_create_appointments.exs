defmodule Dukkadee.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :start_time, :utc_datetime, null: false
      add :end_time, :utc_datetime, null: false
      add :customer_name, :string, null: false
      add :customer_email, :string, null: false
      add :customer_phone, :string
      add :status, :string, default: "scheduled", null: false
      add :notes, :text
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:appointments, [:product_id])
    create index(:appointments, [:status])
    create index(:appointments, [:start_time, :end_time])
  end
end
