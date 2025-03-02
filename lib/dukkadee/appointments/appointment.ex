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
    
    belongs_to :product, Dukkadee.Products.Product
    
    timestamps()
  end

  def changeset(%Appointment{} = appointment, attrs) do
    appointment
    |> cast(attrs, [:start_time, :end_time, :customer_name, :customer_email, :customer_phone, :status, :notes, :product_id])
    |> validate_required([:start_time, :end_time, :customer_name, :customer_email, :product_id])
    |> validate_time_range()
    |> validate_inclusion(:status, ["scheduled", "confirmed", "cancelled", "completed"])
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
end
