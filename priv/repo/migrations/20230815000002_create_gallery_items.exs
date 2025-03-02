defmodule Dukkadee.Repo.Migrations.CreateGalleryItems do
  use Ecto.Migration

  def change do
    create table(:gallery_items) do
      add :title, :string, null: false
      add :description, :text
      add :before_image, :string, null: false
      add :after_image, :string, null: false
      add :category, :string
      add :tattoo_size, :string
      add :tattoo_colors, {:array, :string}
      add :sessions_required, :integer
      add :published, :boolean, default: false
      add :featured, :boolean, default: false
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:gallery_items, [:store_id])
    create index(:gallery_items, [:category])
    create index(:gallery_items, [:published])
    create index(:gallery_items, [:featured])
  end
end
