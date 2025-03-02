# Phoenix Controllers

Controllers in Phoenix are modules that contain actions. Actions are functions that handle requests and return responses. Controllers are the C in MVC (Model-View-Controller).

## Basic Controller

A basic Phoenix controller looks like this:

```elixir
defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  def index(conn, _params) do
    users = MyApp.Accounts.list_users()
    render(conn, :index, users: users)
  end

  def show(conn, %{"id" => id}) do
    user = MyApp.Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def new(conn, _params) do
    changeset = MyApp.Accounts.change_user(%MyApp.Accounts.User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case MyApp.Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = MyApp.Accounts.get_user!(id)
    changeset = MyApp.Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = MyApp.Accounts.get_user!(id)

    case MyApp.Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = MyApp.Accounts.get_user!(id)
    {:ok, _user} = MyApp.Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end
```

## Controller Actions

Controller actions are functions that take two arguments:

1. `conn`: The connection struct
2. `params`: The request parameters

Actions typically perform the following steps:

1. Extract data from the request parameters
2. Interact with the application's context modules
3. Render a template or redirect to another action

## Rendering Templates

Controllers render templates using the `render/3` function:

```elixir
def index(conn, _params) do
  users = MyApp.Accounts.list_users()
  render(conn, :index, users: users)
end
```

In Phoenix 1.7+, this renders the template defined in the corresponding view module:

```elixir
defmodule MyAppWeb.UserHTML do
  use MyAppWeb, :html

  embed_templates "user_html/*"

  @doc """
  Renders a user list.
  """
  attr :users, :list, required: true

  def user_list(assigns) do
    ~H"""
    <div class="user-list">
      <ul>
        <li :for={user <- @users}>
          <.link navigate={~p"/users/#{user}"}><%= user.name %></.link>
        </li>
      </ul>
    </div>
    """
  end
end
```

## Redirecting

Controllers can redirect to another action using the `redirect/2` function:

```elixir
def create(conn, %{"user" => user_params}) do
  case MyApp.Accounts.create_user(user_params) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: ~p"/users/#{user}")

    {:error, %Ecto.Changeset{} = changeset} ->
      render(conn, :new, changeset: changeset)
  end
end
```

## Flash Messages

Controllers can set flash messages using the `put_flash/3` function:

```elixir
conn
|> put_flash(:info, "User created successfully.")
|> redirect(to: ~p"/users/#{user}")
```

Flash messages are stored in the session and are available in the next request.

## Status Codes

Controllers can set the response status code using the `put_status/2` function:

```elixir
conn
|> put_status(:not_found)
|> render(:not_found)
```

## Content Types

Controllers can set the response content type using the `put_resp_content_type/2` function:

```elixir
conn
|> put_resp_content_type("application/json")
|> send_resp(200, Jason.encode!(data))
```

## Plugs

Controllers can use plugs to perform common tasks:

```elixir
defmodule MyAppWeb.UserController do
  use MyAppWeb, :controller

  plug :authenticate_user when action in [:edit, :update, :delete]
  plug :load_user when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    users = MyApp.Accounts.list_users()
    render(conn, :index, users: users)
  end

  # Other actions...

  defp authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: ~p"/login")
      |> halt()
    end
  end

  defp load_user(conn, _opts) do
    user = MyApp.Accounts.get_user!(conn.params["id"])
    assign(conn, :user, user)
  end
end
```

## JSON Responses

Controllers can return JSON responses:

```elixir
def index(conn, _params) do
  users = MyApp.Accounts.list_users()
  render(conn, :index, users: users)
end
```

With a corresponding JSON view:

```elixir
defmodule MyAppWeb.UserJSON do
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email
    }
  end
end
```

## Controllers in Dukkadee E-Commerce Platform

In the Dukkadee platform, we use controllers for our traditional web pages and API endpoints:

1. **Web Controllers**: Handle traditional web requests and render HTML templates
2. **API Controllers**: Handle API requests and return JSON responses
3. **Admin Controllers**: Handle admin-specific requests

Our controllers follow the Phoenix conventions and interact with our context modules to fetch and manipulate data. They also use plugs for common tasks like authentication and authorization.

For interactive features, we use LiveView instead of traditional controllers, as it provides a more seamless user experience with real-time updates.
