defmodule Dukkadee.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Products.Product

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :currency, :string, default: "USD"
    field :images, {:array, :string}, default: []
    field :requires_appointment, :boolean, default: false
    field :is_published, :boolean, default: true
    field :category, :string
    field :tags, {:array, :string}, default: []
    
    belongs_to :store, Dukkadee.Stores.Store
    has_many :variants, Dukkadee.Products.Variant
    has_many :appointments, Dukkadee.Appointments.Appointment
    
    timestamps()
  end

  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :description, :price, :currency, :images, :requires_appointment, :is_published, :category, :tags, :store_id])
    |> validate_required([:name, :price, :store_id])
    |> validate_number(:price, greater_than_or_equal_to: 0)
  end
end
