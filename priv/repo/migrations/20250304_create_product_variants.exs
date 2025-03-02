defmodule Dukkadee.Repo.Migrations.CreateProductVariants20250304 do
  use Ecto.Migration

  def change do
    create table(:product_variants) do
      add :name, :string, null: false
      add :sku, :string
      add :price, :decimal, precision: 10, scale: 2
      add :options, :map, default: %{}
      add :stock, :integer, default: 0, null: false
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:product_variants, [:product_id])
    create unique_index(:product_variants, [:sku])
  end
end
