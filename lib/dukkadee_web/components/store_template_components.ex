defmodule DukkadeeWeb.StoreTemplateComponents do
  use Phoenix.Component

  import Phoenix.HTML
  import DukkadeeWeb.CoreComponents
  import DukkadeeWeb.Gettext

  def template_card(assigns) do
    ~H"""
    <div class="bg-white shadow rounded-lg p-6">
      <h3 class="text-lg font-semibold text-gray-900"><%= @template.name %></h3>
      <p class="mt-2 text-sm text-gray-600"><%= @template.description %></p>
      <div class="mt-4">
        <.button phx-click="select_template" phx-value-id={@template.id}>
          Select Template
        </.button>
      </div>
    </div>
    """
  end
end
