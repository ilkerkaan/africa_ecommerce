# Phoenix Contexts

Contexts in Phoenix are modules that group related functionality. They are the boundary between your web interface and your business logic. Contexts are the M in MVC (Model-View-Controller).

## What are Contexts?

Contexts are modules that define a boundary around a set of related functions and data. They are responsible for:

1. **Data Access**: Fetching and manipulating data from the database
2. **Business Logic**: Implementing business rules and validations
3. **Domain Logic**: Encapsulating domain-specific logic

Contexts help you organize your code and make it more maintainable by separating concerns.

## Basic Context

A basic Phoenix context looks like this:

```elixir
defmodule MyApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
```

## Context Organization

Contexts are typically organized by domain:

```
lib/my_app/
  accounts/           # Context for user accounts
    user.ex           # User schema
    credential.ex     # Credential schema
  accounts.ex         # Accounts context module

  catalog/            # Context for product catalog
    product.ex        # Product schema
    category.ex       # Category schema
  catalog.ex          # Catalog context module

  sales/              # Context for sales
    order.ex          # Order schema
    line_item.ex      # Line item schema
  sales.ex            # Sales context module
```

## Context Functions

Context functions typically fall into these categories:

1. **Query Functions**: Functions that fetch data from the database
2. **Mutation Functions**: Functions that create, update, or delete data
3. **Business Logic Functions**: Functions that implement business rules
4. **Helper Functions**: Functions that help with common tasks

## Cross-Context Communication

Contexts can communicate with each other, but this should be done carefully to avoid tight coupling:

```elixir
defmodule MyApp.Sales do
  @moduledoc """
  The Sales context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Sales.Order
  alias MyApp.Accounts

  @doc """
  Creates an order for a user.
  """
  def create_order_for_user(user_id, attrs \\ %{}) do
    # Get the user from the Accounts context
    user = Accounts.get_user!(user_id)

    # Create the order
    %Order{}
    |> Order.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end
end
```

## Testing Contexts

Contexts should be tested independently of the web interface:

```elixir
defmodule MyApp.AccountsTest do
  use MyApp.DataCase

  alias MyApp.Accounts

  describe "users" do
    alias MyApp.Accounts.User

    @valid_attrs %{name: "John Doe", email: "john@example.com"}
    @update_attrs %{name: "Jane Doe", email: "jane@example.com"}
    @invalid_attrs %{name: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "John Doe"
      assert user.email == "john@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.name == "Jane Doe"
      assert user.email == "jane@example.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
```

## Best Practices for Contexts

1. **Group related functionality**: Each context should group related functionality.
2. **Keep contexts focused**: Each context should have a clear responsibility.
3. **Avoid circular dependencies**: Contexts should not depend on each other in a circular way.
4. **Document context functions**: Use `@doc` to document context functions.
5. **Test contexts thoroughly**: Write tests for all context functions.
6. **Use meaningful names**: Context names should reflect their purpose.
7. **Keep public API small**: Only expose functions that are needed by the web interface.
8. **Use private functions for implementation details**: Hide implementation details behind private functions.

## Contexts in Dukkadee E-Commerce Platform

In the Dukkadee platform, we use contexts to organize our business logic:

1. **Stores Context**: Manages store creation, configuration, and settings
2. **Products Context**: Manages product catalog, categories, and inventory
3. **Customers Context**: Manages customer accounts, profiles, and preferences
4. **Orders Context**: Manages orders, payments, and fulfillment
5. **Marketing Context**: Manages promotions, discounts, and marketing campaigns

These contexts provide a clear separation of concerns and make our codebase more maintainable. They also allow us to implement our dual architectural approach:

1. **Direct In-App Architecture**: Our web interface calls context functions directly for maximum performance
2. **API Development**: Our API controllers call the same context functions, ensuring consistency between our direct and API interfaces
