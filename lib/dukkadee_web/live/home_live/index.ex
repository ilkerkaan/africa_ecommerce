defmodule DukkadeeWeb.HomeLive.Index do
  use DukkadeeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Welcome to Dukkadee")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white">
      <div class="relative isolate px-6 pt-14 lg:px-8">
        <div class="mx-auto max-w-2xl py-32 sm:py-48 lg:py-56">
          <div class="text-center">
            <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-6xl">
              Create your online store in just 1 minute
            </h1>
            <p class="mt-6 text-lg leading-8 text-gray-600">
              Dukkadee helps you launch your e-commerce business quickly. Import products from Instagram,
              customize your store, and start selling today.
            </p>
            <div class="mt-10 flex items-center justify-center gap-x-6">
              <a
                href="/open_new_store"
                class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
              >
                Create your store
              </a>
              <a href="/marketplace" class="text-sm font-semibold leading-6 text-gray-900">
                Browse marketplace <span aria-hidden="true">→</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
