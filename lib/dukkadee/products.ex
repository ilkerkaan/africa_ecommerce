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
  List featured products for a specific store.
  
  Returns a list of up to `limit` featured products for the given store.
  Featured products are determined by the is_featured flag.
  """
  def list_featured_products_by_store(store_id, limit \\ 4) do
    Product
    |> where([p], p.store_id == ^store_id)
    |> where([p], p.is_published == true)
    |> order_by([p], [desc: p.is_featured, desc: p.inserted_at])
    |> limit(^limit)
    |> Repo.all()
  end
  
  @doc """
  List all product categories for a specific store.
  
  Returns a unique list of categories used by the store's products.
  """
  def list_categories_by_store(store_id) do
    Product
    |> where([p], p.store_id == ^store_id)
    |> where([p], p.is_published == true)
    |> where([p], not is_nil(p.category))
    |> select([p], p.category)
    |> distinct(true)
    |> Repo.all()
  end
  
  @doc """
  List products by category for a specific store.
  
  Returns a list of products that belong to the specified category in the given store.
  """
  def list_products_by_category(store_id, category, params \\ %{}) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = Map.get(params, "per_page", "12") |> String.to_integer()
    
    Product
    |> where([p], p.store_id == ^store_id)
    |> where([p], p.category == ^category)
    |> where([p], p.is_published == true)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(page: page, page_size: per_page)
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
  Returns an `%Ecto.Changeset{}` for tracking variant changes.
  """
  def change_variant(%Variant{} = variant, attrs \\ %{}) do
    Variant.changeset(variant, attrs)
  end
  
  @doc """
  Search products by name or description within a store.
  
  Returns a paginated list of products matching the search term.
  """
  def search_products(store_id, search_term, params \\ %{}) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    per_page = Map.get(params, "per_page", "12") |> String.to_integer()
    
    search_term = "%#{search_term}%"
    
    Product
    |> where([p], p.store_id == ^store_id)
    |> where([p], p.is_published == true)
    |> where([p], ilike(p.name, ^search_term) or ilike(p.description, ^search_term))
    |> order_by([p], desc: p.inserted_at)
    |> Repo.paginate(page: page, page_size: per_page)
  end
end
