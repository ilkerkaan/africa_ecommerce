defmodule Dukkadee.Repo.Migrations.CreateImportJobs do
  use Ecto.Migration

  def change do
    create table(:import_jobs) do
      add :source_url, :string, null: false
      add :status, :string, null: false
      add :progress, :integer, default: 0
      add :current_step, :string
      add :steps_completed, :integer, default: 0
      add :total_steps, :integer, default: 5
      add :error_message, :text
      add :completed_at, :utc_datetime
      
      add :user_id, references(:users, on_delete: :restrict), null: false
      add :store_id, references(:stores, on_delete: :restrict)

      timestamps()
    end

    create index(:import_jobs, [:user_id])
    create index(:import_jobs, [:store_id])
    create index(:import_jobs, [:status])
    create index(:import_jobs, [:inserted_at])
  end
end
