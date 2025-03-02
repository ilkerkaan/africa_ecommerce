defmodule Dukkadee.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def up do
    # Drop the existing stores table if needed
    execute "DROP TABLE IF EXISTS stores CASCADE"
    
    # Recreate the stores table with the correct structure
    create table(:stores) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :domain, :string
      add :description, :text
      add :logo_url, :string
      add :primary_color, :string, default: "#fddb24"
      add :secondary_color, :string, default: "#b7acd4"
      add :accent_color, :string, default: "#272727"
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:stores, [:slug])
    create unique_index(:stores, [:domain])
    create index(:stores, [:user_id])
  end

  def down do
    drop table(:stores)
  end
end
