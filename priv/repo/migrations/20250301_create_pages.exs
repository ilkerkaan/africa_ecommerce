defmodule Dukkadee.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :content, :text, null: false
      add :is_published, :boolean, default: true, null: false
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:pages, [:store_id])
    create unique_index(:pages, [:store_id, :slug])
  end
end
