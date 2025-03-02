# Phoenix Components

Phoenix Components are reusable UI elements that can be used across your application. They help maintain consistency and reduce duplication in your templates.

## Function Components

Function components are the simplest form of components in Phoenix. They are functions that render HTML.

```elixir
def button(assigns) do
  ~H"""
  <button class="btn">
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

You can use this component in your templates:

```heex
<.button>Click me</.button>
```

## Component Attributes

Components can accept attributes that modify their behavior or appearance:

```elixir
attr :class, :string, default: nil
attr :type, :string, default: "button"
attr :rest, :global

def button(assigns) do
  ~H"""
  <button
    type={@type}
    class={["btn", @class]}
    {@rest}
  >
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

## Component Slots

Slots allow you to pass content to a component:

```elixir
slot :inner_block, required: true
slot :header
slot :footer

def card(assigns) do
  ~H"""
  <div class="card">
    <%= if @header do %>
      <div class="card-header">
        <%= render_slot(@header) %>
      </div>
    <% end %>
    <div class="card-body">
      <%= render_slot(@inner_block) %>
    </div>
    <%= if @footer do %>
      <div class="card-footer">
        <%= render_slot(@footer) %>
      </div>
    <% end %>
  </div>
  """
end
```

You can use this component with slots:

```heex
<.card>
  <:header>Card Title</:header>
  Card content
  <:footer>Card Footer</:footer>
</.card>
```

## Component Modules

For more complex components, you can create a dedicated module:

```elixir
defmodule MyAppWeb.Components do
  use Phoenix.Component

  attr :class, :string, default: nil
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button class={["btn", @class]}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
end
```

## Core Components

Phoenix 1.7+ includes a set of core components that provide common UI elements:

- `.button`: Renders a button
- `.form`: Renders a form
- `.input`: Renders a form input
- `.label`: Renders a form label
- `.error`: Renders a form error
- `.header`: Renders a header
- `.table`: Renders a table
- `.modal`: Renders a modal dialog
- `.flash`: Renders a flash message
- `.icon`: Renders an icon

These components are defined in `core_components.ex` and can be customized for your application.

## JavaScript Interoperability

Components can interact with JavaScript through Phoenix.LiveView.JS:

```elixir
import Phoenix.LiveView.JS

def show_modal(js \\ %JS{}, id) do
  js
  |> JS.show(to: "##{id}")
  |> JS.focus_first(to: "##{id}")
end

def hide_modal(js \\ %JS{}, id) do
  js
  |> JS.hide(to: "##{id}")
  |> JS.focus(to: "##{id}-trigger")
end
```

## Avoiding Name Conflicts

When importing Phoenix.LiveView.JS, be careful about name conflicts with your own functions. You can use the `except` option to exclude specific functions:

```elixir
import Phoenix.LiveView.JS, except: [show: 2, hide: 2]
```

Alternatively, you can rename your functions to avoid conflicts:

```elixir
def show_flash(js \\ %JS{}, selector) do
  # Implementation
end

def hide_flash(js \\ %JS{}, selector) do
  # Implementation
end
```

## Best Practices for Components

1. **Keep components focused**: Each component should do one thing well.
2. **Use descriptive names**: Component names should clearly indicate their purpose.
3. **Document components**: Use `@doc` to document your components.
4. **Validate attributes**: Use `attr` to validate component attributes.
5. **Use slots for content**: Use slots to pass content to components.
6. **Use CSS classes for styling**: Use CSS classes to style components.
7. **Use JS commands for interactivity**: Use JS commands for interactive components.
8. **Test components**: Write tests for your components.

## Components in Dukkadee E-Commerce Platform

In the Dukkadee platform, we use components extensively to maintain consistency and reduce duplication:

1. **Core Components**: We use Phoenix's core components for common UI elements.
2. **Custom Components**: We have created custom components for e-commerce-specific UI elements.
3. **Shadcn UI Components**: We have integrated Shadcn UI components for a modern look and feel.
4. **LiveComponents**: We use LiveComponents for interactive elements.

These components help us maintain a consistent UI across the platform while reducing duplication and improving maintainability.
