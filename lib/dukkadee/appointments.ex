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
