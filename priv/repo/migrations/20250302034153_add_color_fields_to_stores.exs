defmodule Dukkadee.Repo.Migrations.AddColorFieldsToStores do
  use Ecto.Migration

  def change do
    alter table(:stores) do
      add :primary_color, :string, default: "#336699"
      add :secondary_color, :string, default: "#FFCC00"
      add :accent_color, :string, default: "#FF6633"
      
      # Remove columns that were renamed or no longer used
      remove :theme, :string
      remove :self_hosted, :boolean
      remove :self_hosted_url, :string
      remove :user_id, references(:users, on_delete: :delete_all)
      
      # Add the owner_id column to replace user_id
      add :owner_id, :integer, null: false
    end
  end
end
