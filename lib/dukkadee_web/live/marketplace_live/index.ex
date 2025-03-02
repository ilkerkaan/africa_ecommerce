defmodule DukkadeeWeb.MarketplaceLive.Index do
  use DukkadeeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    # In a real implementation, we would fetch products from the database
    {:ok, assign(socket, 
      page_title: "Marketplace",
      products: sample_products()
    )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="flex justify-between items-center py-6">
        <h1 class="text-2xl font-bold text-gray-900">Global Marketplace</h1>
        <div>
          <form phx-change="search" class="flex gap-2">
            <input 
              type="text" 
              name="q" 
              placeholder="Search products..." 
              class="border border-gray-300 rounded-md px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500"
            />
            <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded-md">
              Search
            </button>
          </form>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-y-10 gap-x-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 xl:gap-x-8">
        <%= for product <- @products do %>
          <div class="group">
            <div class="aspect-w-1 aspect-h-1 w-full overflow-hidden rounded-lg bg-gray-200">
              <img 
                src={product.image_url} 
                alt={product.name} 
                class="h-full w-full object-cover object-center group-hover:opacity-75"
              />
            </div>
            <div class="mt-4 flex justify-between">
              <div>
                <h3 class="text-sm text-gray-700"><%= product.name %></h3>
                <p class="mt-1 text-sm text-gray-500"><%= product.store_name %></p>
              </div>
              <p class="text-sm font-medium text-gray-900">$<%= product.price %></p>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    # In a real implementation, this would search the database
    # For now, we just filter the sample products by name
    filtered_products = 
      sample_products()
      |> Enum.filter(fn product -> 
        String.contains?(String.downcase(product.name), String.downcase(query))
      end)
    
    {:noreply, assign(socket, products: filtered_products)}
  end

  # Sample product data for demo purposes
  defp sample_products do
    [
      %{
        id: 1,
        name: "African Print Dress",
        price: 79.99,
        image_url: "https://images.unsplash.com/photo-1565115021788-6d3f1ade4980?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
        store_name: "Ankara Designs"
      },
      %{
        id: 2,
        name: "Handmade Basket",
        price: 45.00,
        image_url: "https://images.unsplash.com/photo-1601145608286-0e31a0ce0864?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
        store_name: "African Artisans"
      },
      %{
        id: 3,
        name: "Beaded Necklace",
        price: 29.95,
        image_url: "https://images.unsplash.com/photo-1533468432434-200de3b5d528?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
        store_name: "Maasai Treasures"
      },
      %{
        id: 4,
        name: "Wooden Sculpture",
        price: 129.99,
        image_url: "https://images.unsplash.com/photo-1461695008884-244102c6374a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
        store_name: "Safari Art"
      },
      %{
        id: 5,
        name: "Kente Cloth",
        price: 89.50,
        image_url: "https://images.unsplash.com/photo-1590047519833-0f00b8222e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
        store_name: "Ghana Textiles"
      },
      %{
        id: 6,
        name: "Leather Sandals",
        price: 59.99,
        image_url: "https://images.unsplash.com/photo-1562273138-f46be4ebdf33?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
        store_name: "Savanna Steps"
      }
    ]
  end
end
