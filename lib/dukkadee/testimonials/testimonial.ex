defmodule Dukkadee.Testimonials.Testimonial do
  use Ecto.Schema
  import Ecto.Changeset

  schema "testimonials" do
    field :customer_name, :string
    field :customer_image, :string
    field :content, :string
    field :rating, :integer
    field :service_type, :string
    field :published, :boolean, default: false
    field :featured, :boolean, default: false
    
    belongs_to :store, Dukkadee.Stores.Store
    
    timestamps()
  end

  def changeset(testimonial, attrs) do
    testimonial
    |> cast(attrs, [:customer_name, :customer_image, :content, :rating, :service_type, :published, :featured, :store_id])
    |> validate_required([:customer_name, :content, :rating, :store_id])
    |> validate_inclusion(:rating, 1..5)
    |> validate_length(:content, min: 10, max: 1000)
  end
end
