# Phoenix LiveView

Phoenix LiveView is a powerful library that enables rich, real-time user experiences with server-rendered HTML. It allows us to build interactive, real-time applications without writing much JavaScript.

## Core Concepts

### LiveView Lifecycle

A LiveView has the following lifecycle:

1. **Mount**: Called when the LiveView is first rendered. This is where you set up the initial state.
2. **Handle Parameters**: Called after mount and whenever the URL parameters change.
3. **Render**: Called to render the LiveView template.
4. **Handle Events**: Called when events are triggered from the client.
5. **Handle Info**: Called when the LiveView process receives messages.
6. **Terminate**: Called when the LiveView process is shutting down.

### LiveView State

LiveView maintains state on the server in the LiveView process. This state is accessible in the template and can be updated by event handlers.

```elixir
def mount(_params, _session, socket) do
  {:ok, assign(socket, count: 0)}
end
```

### LiveView Events

Events are triggered from the client and handled on the server. They can be triggered by user interactions like clicks or form submissions.

```elixir
def handle_event("increment", _params, socket) do
  {:noreply, assign(socket, count: socket.assigns.count + 1)}
end
```

In the template:

```heex
<button phx-click="increment">Increment</button>
```

### LiveView Bindings

LiveView provides several bindings that can be used in templates:

- `phx-click`: Triggers a click event
- `phx-submit`: Triggers a form submission event
- `phx-change`: Triggers an event when a form field changes
- `phx-keydown`: Triggers an event when a key is pressed
- `phx-keyup`: Triggers an event when a key is released
- `phx-blur`: Triggers an event when an element loses focus
- `phx-focus`: Triggers an event when an element gains focus

## LiveComponents

LiveComponents are reusable, stateful components that can be used in LiveViews. They come in two varieties:

### Stateless Components

Stateless components are simple functions that render HTML. They don't maintain their own state.

```elixir
def button(assigns) do
  ~H"""
  <button class="btn">
    <%= render_slot(@inner_block) %>
  </button>
  """
end
```

### Stateful Components

Stateful components are modules that implement the `Phoenix.LiveComponent` behaviour. They maintain their own state and have their own lifecycle.

```elixir
defmodule MyAppWeb.CounterComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      <h2>Count: <%= @count %></h2>
      <button phx-click="increment" phx-target={@myself}>Increment</button>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + 1)}
  end
end
```

## LiveView Uploads

LiveView provides built-in support for file uploads with progress tracking and validation.

```elixir
def mount(_params, _session, socket) do
  {:ok,
   socket
   |> assign(:uploaded_files, [])
   |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
end
```

In the template:

```heex
<form phx-submit="save" phx-change="validate">
  <.live_file_input upload={@uploads.avatar} />
  <button type="submit">Upload</button>
</form>
```

## JS Interoperability

LiveView provides a JavaScript interoperability layer that allows you to execute JavaScript commands from the server.

```elixir
def handle_event("show_modal", _params, socket) do
  {:noreply, push_event(socket, "show-modal", %{id: "my-modal"})}
end
```

On the client:

```javascript
let Hooks = {}
Hooks.Modal = {
  mounted() {
    this.handleEvent("show-modal", ({id}) => {
      document.getElementById(id).classList.remove("hidden")
    })
  }
}

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks})
```

## LiveView Navigation

LiveView provides client-side navigation through the `live_patch` and `live_redirect` functions.

- `live_patch`: Updates the URL without a full page reload
- `live_redirect`: Navigates to a new LiveView with a full LiveView lifecycle

```elixir
<.link patch={~p"/users/#{@user}"}>Show</.link>
<.link navigate={~p"/users"}>Back</.link>
```

## LiveView in Dukkadee E-Commerce Platform

In the Dukkadee platform, we use LiveView extensively for interactive features:

1. **Real-time URL validation** in store creation flow
2. **LiveView uploads** for product images with progress indicators
3. **Real-time admin dashboard** with analytics
4. **PubSub system** for broadcasting events across the application
5. **Presence tracking** for monitoring active users
6. **JavaScript hooks** for enhanced client-side functionality
7. **LiveView JS interoperability** for smooth UI interactions

These features provide real-time capabilities that enhance the user experience and make the platform more interactive.
