# Phoenix Routing

Phoenix routing is responsible for mapping HTTP requests to controller actions. It's defined in the `router.ex` file in your application.

## Basic Routing

A basic Phoenix router looks like this:

```elixir
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete
  end

  scope "/api", MyAppWeb do
    pipe_through :api

    resources "/users", UserController
  end
end
```

## Route Helpers

Phoenix generates route helpers for each route. For example, for the route `get "/users/:id", UserController, :show`, Phoenix generates a helper function `Routes.user_path(conn, :show, id)`.

In Phoenix 1.7+, you can use sigils for route helpers:

```elixir
~p"/users/#{user.id}"
```

## Resources

Phoenix provides a shorthand for defining RESTful routes:

```elixir
resources "/users", UserController
```

This expands to:

```elixir
get "/users", UserController, :index
get "/users/:id", UserController, :show
get "/users/new", UserController, :new
post "/users", UserController, :create
get "/users/:id/edit", UserController, :edit
put "/users/:id", UserController, :update
patch "/users/:id", UserController, :update
delete "/users/:id", UserController, :delete
```

You can customize which actions are generated:

```elixir
resources "/users", UserController, only: [:index, :show]
resources "/users", UserController, except: [:delete]
```

## Nested Resources

You can nest resources to represent parent-child relationships:

```elixir
resources "/users", UserController do
  resources "/posts", PostController
end
```

This generates routes like:

```
/users/:user_id/posts
/users/:user_id/posts/:id
```

## Scopes

Scopes allow you to group routes by a common path prefix or module prefix:

```elixir
scope "/admin", MyAppWeb.Admin do
  pipe_through :browser

  resources "/users", UserController
end
```

This generates routes like:

```
/admin/users
/admin/users/:id
```

And the controller will be `MyAppWeb.Admin.UserController`.

## Pipelines

Pipelines allow you to apply a series of plugs to a group of routes:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug :put_root_layout, {MyAppWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers
end

pipeline :api do
  plug :accepts, ["json"]
end

pipeline :authenticated do
  plug MyAppWeb.AuthPlug
end

scope "/", MyAppWeb do
  pipe_through [:browser, :authenticated]

  resources "/users", UserController
end
```

## LiveView Routing

Phoenix provides special routes for LiveView:

```elixir
live "/", PageLive, :index
live "/users", UserLive.Index, :index
live "/users/new", UserLive.Index, :new
live "/users/:id", UserLive.Show, :show
live "/users/:id/edit", UserLive.Show, :edit
```

You can also use the `live_session` macro to group LiveView routes that share the same session:

```elixir
live_session :authenticated, on_mount: {MyAppWeb.LiveAuth, :ensure_authenticated} do
  live "/users", UserLive.Index, :index
  live "/users/:id", UserLive.Show, :show
end
```

## Path Helpers

Phoenix provides helpers for generating paths and URLs:

```elixir
# In a controller or view
Routes.user_path(conn, :show, user)
Routes.user_url(conn, :show, user)

# In a LiveView
~p"/users/#{user.id}"
```

## Routing in Dukkadee E-Commerce Platform

In the Dukkadee platform, we use routing to organize our application:

1. **Public Routes**: Routes for public-facing pages like the homepage and product listings
2. **Store Routes**: Routes for store-specific pages
3. **Admin Routes**: Routes for store administration
4. **API Routes**: Routes for our RESTful and GraphQL APIs
5. **LiveView Routes**: Routes for our LiveView components

Our routing structure reflects our dual architectural approach:

```elixir
# Direct In-App Architecture for Dukkadee-hosted solution
scope "/", DukkadeeWeb do
  pipe_through :browser

  live "/", HomeLive.Index, :index
  live "/stores/:store_id", StoreLive.Show, :show
  # More routes...
end

# Admin routes
scope "/admin", DukkadeeWeb.Admin, as: :admin do
  pipe_through [:browser, :require_admin]

  live "/", DashboardLive, :index
  live "/stores", StoreLive.Index, :index
  # More routes...
end

# API for self-hosted store integration and third-party services
scope "/api", DukkadeeWeb.API do
  pipe_through :api

  resources "/stores", StoreController
  # More routes...
end
```

This routing structure allows us to maintain a clear separation between different parts of our application while still leveraging the performance benefits of our direct in-app architecture.
