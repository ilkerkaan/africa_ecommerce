defmodule Dukkadee.Repo.Migrations.CreateStores20250302 do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :domain, :string
      add :description, :text
      add :logo_url, :string
      add :theme, :string, default: "default", null: false
      add :self_hosted, :boolean, default: false, null: false
      add :self_hosted_url, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:stores, [:slug])
    create unique_index(:stores, [:domain])
    create index(:stores, [:user_id])
  end
end
