defmodule Dukkadee.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :primary_color, :string, default: "#336699"
    field :secondary_color, :string, default: "#FFCC00"
    field :accent_color, :string, default: "#FF6633"
    field :logo_url, :string
    field :owner_id, :integer

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :slug, :description, :primary_color, :secondary_color, :accent_color, :logo_url, :owner_id])
    |> validate_required([:name, :slug, :owner_id])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:slug, min: 2, max: 100)
    |> validate_format(:slug, ~r/^[a-z0-9\-]+$/, message: "must contain only lowercase letters, numbers, and hyphens")
    |> unique_constraint(:slug)
  end
end
