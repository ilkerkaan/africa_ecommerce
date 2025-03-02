defmodule Dukkadee.Repo.Migrations.CreateStaffProfiles do
  use Ecto.Migration

  def change do
    create table(:staff_profiles) do
      add :name, :string, null: false
      add :position, :string, null: false
      add :bio, :text, null: false
      add :photo, :string
      add :certifications, {:array, :string}
      add :specialties, {:array, :string}
      add :featured, :boolean, default: false
      add :email, :string
      add :display_order, :integer, default: 999
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:staff_profiles, [:store_id])
    create index(:staff_profiles, [:featured])
    create index(:staff_profiles, [:display_order])
    create unique_index(:staff_profiles, [:name, :store_id])
  end
end
