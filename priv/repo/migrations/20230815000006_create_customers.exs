defmodule Dukkadee.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :email, :string, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :first_name, :string
      add :last_name, :string
      add :phone, :string
      add :profile_photo, :string
      add :date_of_birth, :date
      add :address, :string
      add :city, :string
      add :country, :string
      add :postal_code, :string
      add :preferences, :map

      timestamps()
    end

    create unique_index(:customers, [:email])
  end
end
