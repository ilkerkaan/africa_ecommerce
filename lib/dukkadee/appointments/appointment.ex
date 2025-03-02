defmodule Dukkadee.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Dukkadee.Appointments.Appointment

  schema "appointments" do
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :customer_name, :string
    field :customer_email, :string
    field :customer_phone, :string
    field :status, :string, default: "scheduled" # scheduled, confirmed, cancelled, completed
    field :notes, :string
    
    # Tattoo removal specific fields
    field :tattoo_size, :string # small, medium, large, extra_large
    field :tattoo_age, :string # less_than_1, 1_to_5, 5_to_10, more_than_10
    field :tattoo_colors, {:array, :string} # black, blue, red, green, yellow, orange, purple, white, other
    
    belongs_to :product, Dukkadee.Products.Product
    belongs_to :customer, Dukkadee.Customers.Customer
    
    timestamps()
  end

  def changeset(%Appointment{} = appointment, attrs) do
    appointment
    |> cast(attrs, [:start_time, :end_time, :customer_name, :customer_email, :customer_phone, :status, :notes, :product_id, :customer_id, :tattoo_size, :tattoo_age, :tattoo_colors])
    |> validate_required([:start_time, :end_time, :customer_name, :customer_email, :product_id, :customer_id])
    |> validate_time_range()
    |> validate_inclusion(:status, ["scheduled", "confirmed", "cancelled", "completed"])
    |> validate_tattoo_fields()
  end

  defp validate_time_range(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    if start_time && end_time && DateTime.compare(end_time, start_time) == :lt do
      add_error(changeset, :end_time, "must be after start time")
    else
      changeset
    end
  end
  
  defp validate_tattoo_fields(changeset) do
    product_id = get_field(changeset, :product_id)
    
    # Only validate tattoo fields for tattoo removal products
    # This is a simple check based on product ID - in a real implementation,
    # we would check the product type or category
    if product_id && is_tattoo_removal_product?(product_id) do
      changeset
      |> validate_required([:tattoo_size, :tattoo_age, :tattoo_colors])
      |> validate_inclusion(:tattoo_size, ["small", "medium", "large", "extra_large"])
      |> validate_inclusion(:tattoo_age, ["less_than_1", "1_to_5", "5_to_10", "more_than_10"])
    else
      changeset
    end
  end
  
  # Helper function to determine if a product is a tattoo removal product
  # In a real implementation, this would check the product type or category
  defp is_tattoo_removal_product?(_product_id) do
    # For now, we'll assume any product from the Inkless Is More store is a tattoo removal product
    # In a real implementation, we would query the database to check the product's store or category
    true
  end
end
