defmodule Dukkadee.Appointments do
  @moduledoc """
  The Appointments context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Appointments.Appointment
  alias Dukkadee.Products.Product

  @doc """
  Returns the list of appointments.
  """
  def list_appointments do
    Repo.all(Appointment)
  end

  @doc """
  Returns the list of appointments for a specific product.
  """
  def list_product_appointments(product_id) do
    Appointment
    |> where([a], a.product_id == ^product_id)
    |> Repo.all()
  end

  @doc """
  Returns the list of appointments for a specific store.
  """
  def list_store_appointments(store_id) do
    query = from a in Appointment,
            join: p in Product, on: a.product_id == p.id,
            where: p.store_id == ^store_id,
            preload: [product: p]
            
    Repo.all(query)
  end

  @doc """
  Returns the list of appointments for a specific customer.
  """
  def list_customer_appointments(customer_id) do
    Appointment
    |> where([a], a.customer_id == ^customer_id)
    |> order_by([a], desc: a.start_time)
    |> Repo.all()
  end

  @doc """
  Gets a single appointment.
  """
  def get_appointment(id), do: Repo.get(Appointment, id)

  @doc """
  Creates an appointment.
  """
  def create_appointment(attrs \\ %{}) do
    %Appointment{}
    |> Appointment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an appointment.
  """
  def update_appointment(%Appointment{} = appointment, attrs) do
    appointment
    |> Appointment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an appointment.
  """
  def delete_appointment(%Appointment{} = appointment) do
    Repo.delete(appointment)
  end

  @doc """
  Returns appointments for a date range.
  """
  def get_appointments_in_range(product_id, start_date, end_date) do
    Appointment
    |> where([a], a.product_id == ^product_id)
    |> where([a], a.start_time >= ^start_date and a.end_time <= ^end_date)
    |> where([a], a.status != "cancelled")
    |> Repo.all()
  end

  @doc """
  Checks if a time slot is available.
  """
  def is_time_slot_available?(product_id, start_time, end_time) do
    # Count overlapping appointments
    query = from a in Appointment,
            where: a.product_id == ^product_id,
            where: a.status != "cancelled",
            where: (a.start_time <= ^end_time and a.end_time >= ^start_time),
            select: count(a.id)
            
    Repo.one(query) == 0
  end

  @doc """
  Gets available time slots for a product.
  """
  def get_available_slots(product_id) do
    # Get product details to determine appointment duration
    product = Products.get_product!(product_id)
    duration = product.appointment_duration

    # Get available slots for the next 7 days
    start_date = DateTime.utc_now()
    end_date = DateTime.add(start_date, 7 * 24 * 60 * 60)

    # Generate potential slots
    slots = generate_time_slots(start_date, end_date, duration)

    # Filter out slots that are already booked
    Enum.filter(slots, fn slot ->
      is_time_slot_available?(product_id, slot.start_time, slot.end_time)
    end)
  end

  defp generate_time_slots(start_date, end_date, duration) do
    # Generate time slots between start and end dates
    # This is a simplified implementation - in a real system,
    # we would consider business hours, holidays, etc.
    Stream.unfold(start_date, fn current_time ->
      if DateTime.compare(current_time, end_date) == :lt do
        next_time = DateTime.add(current_time, duration)
        slot = %{start_time: current_time, end_time: next_time}
        {slot, next_time}
      else
        nil
      end
    end)
    |> Enum.to_list()
  end

  @doc """
  Confirms an appointment.
  """
  def confirm_appointment(%Appointment{} = appointment) do
    update_appointment(appointment, %{status: "confirmed"})
  end

  @doc """
  Cancels an appointment.
  """
  def cancel_appointment(%Appointment{} = appointment) do
    update_appointment(appointment, %{status: "cancelled"})
  end

  @doc """
  Completes an appointment.
  """
  def complete_appointment(%Appointment{} = appointment) do
    update_appointment(appointment, %{status: "completed"})
  end
end
