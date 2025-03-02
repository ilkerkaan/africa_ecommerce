defmodule DukkadeeWeb.Router do
  use DukkadeeWeb, :router

  import DukkadeeWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DukkadeeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes that don't require authentication
  scope "/", DukkadeeWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/users/register", UserRegistrationLive, :new
    live "/users/log_in", UserLoginLive, :new
    live "/users/reset_password", UserResetPasswordLive, :new
    live "/users/reset_password/:token", UserResetPasswordLive, :edit
  end

  scope "/", DukkadeeWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update
  end

  # Routes for store domain
  scope "/", DukkadeeWeb, host: "store." do
    pipe_through :browser

    # When accessed via custom domain
    get "/", StoreController, :home, as: :store_home

    # Store public routes
    get "/products", StoreController, :products
    get "/products/:id", StoreController, :product_details
    get "/categories/:category", StoreController, :category_products
    get "/search", StoreController, :search
    get "/page/:slug", StoreController, :page
    get "/book-appointment/:product_id", StoreController, :book_appointment
  end

  # Routes for dukkadee.com
  scope "/", DukkadeeWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/hello", HelloController, :index
    get "/test", TestController, :hello
    live "/home", HomeLive.Index, :index
    live "/marketplace", MarketplaceLive.Index, :index
    live "/marketplace/search", MarketplaceLive.Index, :search
    live "/marketplace/categories/:category", MarketplaceLive.Index, :category
    live "/open_new_store", StoreCreationLive.Index, :index
    
    # Store templates routes
    get "/templates", StoreTemplateController, :index
    get "/templates/import", StoreTemplateController, :import_legacy
    post "/templates/import", StoreTemplateController, :create_from_legacy
    get "/templates/:id", StoreTemplateController, :show
    get "/templates/new/:template_id", StoreTemplateController, :new
    post "/templates/create/:template_id", StoreTemplateController, :create
    
    # Legacy store import routes
    post "/api/legacy-store/import", LegacyStoreController, :import
    get "/legacy-store/import/progress/:id", LegacyStoreController, :progress
  end

  # Store admin routes (require authentication)
  scope "/admin", DukkadeeWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/", AdminLive.Dashboard, :index
    live "/stores", AdminLive.Stores, :index
    live "/stores/new", AdminLive.Stores, :new
    live "/stores/:id", AdminLive.Stores, :show
    live "/stores/:id/edit", AdminLive.Stores, :edit
    
    live "/stores/:store_id/products", AdminLive.Products, :index
    live "/stores/:store_id/products/new", AdminLive.Products, :new
    live "/stores/:store_id/products/:id", AdminLive.Products, :show
    live "/stores/:store_id/products/:id/edit", AdminLive.Products, :edit
    
    live "/stores/:store_id/appointments", AdminLive.Appointments, :index
    live "/stores/:store_id/appointments/new", AdminLive.Appointments, :new
    live "/stores/:store_id/appointments/:id", AdminLive.Appointments, :show
    live "/stores/:store_id/appointments/:id/edit", AdminLive.Appointments, :edit
    
    live "/stores/:store_id/pages", AdminLive.Pages, :index
    live "/stores/:store_id/pages/new", AdminLive.Pages, :new
    live "/stores/:store_id/pages/:id", AdminLive.Pages, :show
    live "/stores/:store_id/pages/:id/edit", AdminLive.Pages, :edit
    
    live "/stores/:store_id/settings", AdminLive.Settings, :index
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:dukkadee, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DukkadeeWeb.Telemetry
    end
  end
end
