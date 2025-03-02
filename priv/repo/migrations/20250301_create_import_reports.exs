defmodule Dukkadee.Repo.Migrations.CreateImportReports do
  use Ecto.Migration

  def change do
    create table(:import_reports) do
      add :products_count, :integer, default: 0
      add :pages_count, :integer, default: 0
      add :images_count, :integer, default: 0
      add :forms_count, :integer, default: 0
      add :redirects_count, :integer, default: 0
      add :warnings_count, :integer, default: 0
      add :errors_count, :integer, default: 0
      add :duration_seconds, :integer
      add :summary, :text
      add :details, :map
      
      add :import_job_id, references(:import_jobs, on_delete: :restrict), null: false
      add :store_id, references(:stores, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:import_reports, [:import_job_id])
    create index(:import_reports, [:store_id])
  end
end
