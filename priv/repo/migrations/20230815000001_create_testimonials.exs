defmodule Dukkadee.Repo.Migrations.CreateTestimonials do
  use Ecto.Migration

  def change do
    create table(:testimonials) do
      add :customer_name, :string, null: false
      add :customer_image, :string
      add :content, :text, null: false
      add :rating, :integer, null: false
      add :service_type, :string
      add :published, :boolean, default: false
      add :featured, :boolean, default: false
      add :store_id, references(:stores, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:testimonials, [:store_id])
    create index(:testimonials, [:published])
    create index(:testimonials, [:featured])
  end
end
