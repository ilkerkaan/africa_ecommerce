defmodule Dukkadee.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :description, :text
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :currency, :string, default: "USD", null: false
      add :images, {:array, :string}, default: []
      add :requires_appointment, :boolean, default: false, null: false
      add :is_published, :boolean, default: true, null: false
      add :category, :string
      add :tags, {:array, :string}, default: []
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:products, [:store_id])
    create index(:products, [:category])
    create index(:products, [:is_published])
  end
end
