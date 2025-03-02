defmodule Dukkadee.Repo.Migrations.AddCustomerIdToAppointments do
  use Ecto.Migration

  def change do
    alter table(:appointments) do
      add :customer_id, references(:customers, on_delete: :nothing), null: false
    end

    create index(:appointments, [:customer_id])
  end
end
