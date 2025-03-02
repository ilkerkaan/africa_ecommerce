defmodule Dukkadee.Stores do
  @moduledoc """
  The Stores context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo

  alias Dukkadee.Stores.Store

  @doc """
  Returns the list of stores.
  """
  def list_stores do
    Repo.all(Store)
  end

  @doc """
  Returns the list of stores owned by a specific user.
  """
  def list_stores_by_owner(user_id) do
    query = from s in Store, where: s.user_id == ^user_id
    Repo.all(query)
  end

  @doc """
  Gets a single store.
  """
  def get_store(id), do: Repo.get(Store, id)

  @doc """
  Gets a single store by slug.
  """
  def get_store_by_slug(slug) do
    Repo.get_by(Store, slug: slug)
  end

  @doc """
  Gets a single store by slug, raises an error if not found.
  """
  def get_store_by_slug!(slug) do
    query = from s in Store, where: s.slug == ^slug
    Repo.one!(query)
  end

  @doc """
  Gets a single store by domain.
  """
  def get_store_by_domain(domain) do
    query = from s in Store, where: s.domain == ^domain
    Repo.one(query)
  end

  @doc """
  Creates a store.
  """
  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a store.
  """
  def update_store(%Store{} = store, attrs) do
    store
    |> Store.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a store.
  """
  def delete_store(%Store{} = store) do
    Repo.delete(store)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking store changes.
  """
  def change_store(%Store{} = store, attrs \\ %{}) do
    Store.changeset(store, attrs)
  end

  @doc """
  Search stores by name or description.
  """
  def search_stores(query) do
    wildcard_query = "%#{query}%"
    
    from(s in Store,
      where: ilike(s.name, ^wildcard_query) or ilike(s.description, ^wildcard_query)
    )
    |> Repo.all()
  end
end
