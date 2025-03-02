defmodule Dukkadee.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Dukkadee.Repo
  alias Dukkadee.Products.{Product, Variant}

  @doc """
  Returns the list of products.
  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Returns the list of products for a specific store.
  """
  def list_store_products(store_id) do
    Product
    |> where([p], p.store_id == ^store_id)
    |> Repo.all()
  end

  @doc """
  List products for a specific store.
  """
  def list_products_by_store(store_id) do
    Product
    |> where([p], p.store_id == ^store_id)
    |> Repo.all()
  end

  @doc """
  Gets a single product.
  """
  def get_product(id), do: Repo.get(Product, id)

  @doc """
  Gets a single product or raises an error if not found.
  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Gets a single product with preloaded variants.
  """
  def get_product_with_variants(id) do
    Product
    |> Repo.get(id)
    |> Repo.preload(:variants)
  end

  @doc """
  Creates a product.
  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.
  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.
  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  @doc """
  Deletes a product.
  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns the list of variants for a product.
  """
  def list_product_variants(product_id) do
    Variant
    |> where([v], v.product_id == ^product_id)
    |> Repo.all()
  end

  @doc """
  Gets a single variant.
  """
  def get_variant(id), do: Repo.get(Variant, id)

  @doc """
  Creates a variant.
  """
  def create_variant(attrs \\ %{}) do
    %Variant{}
    |> Variant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a variant.
  """
  def update_variant(%Variant{} = variant, attrs) do
    variant
    |> Variant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a variant.
  """
  def delete_variant(%Variant{} = variant) do
    Repo.delete(variant)
  end

  @doc """
  Searches products across all stores.
  """
  def search_marketplace(term) do
    wildcard_term = "%#{term}%"
    
    Product
    |> where([p], p.is_published == true)
    |> where([p], ilike(p.name, ^wildcard_term) or ilike(p.description, ^wildcard_term) or ^term in p.tags)
    |> Repo.all()
    |> Repo.preload(:store)
  end

  @doc """
  Searches products within a specific store.
  """
  def search_store_products(store_id, term) do
    wildcard_term = "%#{term}%"
    
    Product
    |> where([p], p.store_id == ^store_id and p.is_published == true)
    |> where([p], ilike(p.name, ^wildcard_term) or ilike(p.description, ^wildcard_term) or ^term in p.tags)
    |> Repo.all()
  end

  @doc """
  Filters products by category.
  """
  def filter_by_category(query \\ Product, category) do
    where(query, [p], p.category == ^category)
  end

  @doc """
  Filters products by price range.
  """
  def filter_by_price_range(query \\ Product, min_price, max_price) do
    where(query, [p], p.price >= ^min_price and p.price <= ^max_price)
  end
end
