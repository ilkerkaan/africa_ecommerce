defmodule Dukkadee.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :title, :string, null: false
      add :slug, :string
      add :content, :text, null: false
      add :featured_image, :string
      add :excerpt, :text
      add :published, :boolean, default: false
      add :author, :string
      add :tags, {:array, :string}
      add :published_at, :utc_datetime
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:blog_posts, [:store_id])
    create index(:blog_posts, [:published])
    create index(:blog_posts, [:published_at])
    create unique_index(:blog_posts, [:slug, :store_id])
  end
end
