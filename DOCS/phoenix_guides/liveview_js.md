# Phoenix LiveView JS Interoperability

Phoenix LiveView provides a JavaScript interoperability layer that allows you to execute JavaScript commands from the server. This is done through the `Phoenix.LiveView.JS` module.

## Basic Usage

The `Phoenix.LiveView.JS` module provides functions that return JavaScript commands that can be executed on the client:

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

These functions can be used in templates:

```heex
<button phx-click={show_modal("modal")}>Open Modal</button>
<div id="modal" class="modal" phx-click-away={hide_modal("modal")}>
  <button phx-click={hide_modal("modal")}>Close</button>
  <div>Modal Content</div>
</div>
```

## Available JS Commands

The `Phoenix.LiveView.JS` module provides several functions for common JavaScript operations:

- `JS.add_class/2`: Adds a CSS class to an element
- `JS.remove_class/2`: Removes a CSS class from an element
- `JS.toggle_class/2`: Toggles a CSS class on an element
- `JS.show/2`: Shows an element
- `JS.hide/2`: Hides an element
- `JS.toggle/2`: Toggles an element's visibility
- `JS.set_attribute/3`: Sets an attribute on an element
- `JS.remove_attribute/2`: Removes an attribute from an element
- `JS.focus/2`: Focuses an element
- `JS.focus_first/2`: Focuses the first focusable element within a container
- `JS.push/3`: Pushes an event to the server
- `JS.dispatch/3`: Dispatches a DOM event
- `JS.exec/3`: Executes arbitrary JavaScript
- `JS.transition/3`: Applies a CSS transition to an element

## Chaining Commands

JS commands can be chained together:

```elixir
js
|> JS.hide(to: "#modal")
|> JS.add_class("hidden", to: "#modal-backdrop")
|> JS.push("modal-closed")
```

## Targeting Elements

JS commands can target elements using CSS selectors:

```elixir
JS.show(to: "#modal")
JS.hide(to: ".alert")
JS.toggle(to: "[data-role=dropdown]")
```

## Transitions

The `JS.transition/3` function allows you to apply CSS transitions:

```elixir
JS.transition("fade-in", to: "#modal")
```

You can also specify the transition classes:

```elixir
JS.transition(
  {"transition-all transform ease-out duration-300",
   "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
   "opacity-100 translate-y-0 sm:scale-100"},
  to: "#modal"
)
```

## Custom JS Hooks

For more complex JavaScript interactions, you can define custom hooks:

```javascript
// assets/js/app.js
let Hooks = {}
Hooks.Modal = {
  mounted() {
    this.handleEvent("show-modal", ({id}) => {
      document.getElementById(id).classList.remove("hidden")
    })
    this.handleEvent("hide-modal", ({id}) => {
      document.getElementById(id).classList.add("hidden")
    })
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks})
```

Then you can trigger these events from the server:

```elixir
def handle_event("open_modal", _params, socket) do
  {:noreply, push_event(socket, "show-modal", %{id: "my-modal"})}
end
```

## Avoiding Name Conflicts

When importing `Phoenix.LiveView.JS`, be careful about name conflicts with your own functions. There are several ways to handle this:

### 1. Use the `except` option

```elixir
import Phoenix.LiveView.JS, except: [show: 2, hide: 2]
```

This imports all functions from `Phoenix.LiveView.JS` except `show/2` and `hide/2`.

### 2. Rename your functions

```elixir
def show_flash(js \\ %JS{}, selector) do
  # Implementation
end

def hide_flash(js \\ %JS{}, selector) do
  # Implementation
end
```

### 3. Use the fully qualified name

```elixir
def show_modal(js \\ %JS{}, id) do
  js
  |> Phoenix.LiveView.JS.show(to: "##{id}")
  |> Phoenix.LiveView.JS.focus_first(to: "##{id}")
end
```

### 4. Use an alias

```elixir
alias Phoenix.LiveView.JS

def show_modal(js \\ %JS{}, id) do
  js
  |> JS.show(to: "##{id}")
  |> JS.focus_first(to: "##{id}")
end
```

## JS Interoperability in Dukkadee E-Commerce Platform

In the Dukkadee platform, we use JS interoperability for various interactive features:

1. **Modal dialogs** for product details and checkout
2. **Dropdowns** for navigation and filters
3. **Form validation** with real-time feedback
4. **Image galleries** with transitions
5. **Notifications** that appear and disappear
6. **Cart updates** with animations

These features enhance the user experience by providing smooth, interactive elements without requiring a full page reload.
