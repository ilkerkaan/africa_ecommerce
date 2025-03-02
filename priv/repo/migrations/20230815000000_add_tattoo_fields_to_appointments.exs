defmodule Dukkadee.Repo.Migrations.AddTattooFieldsToAppointments do
  use Ecto.Migration

  def change do
    alter table(:appointments) do
      add :tattoo_size, :string
      add :tattoo_age, :string
      add :tattoo_colors, {:array, :string}
    end
    
    # Create an index for faster queries on tattoo size
    create index(:appointments, [:tattoo_size])
  end
end
