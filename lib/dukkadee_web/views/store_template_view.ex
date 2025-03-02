defmodule DukkadeeWeb.StoreTemplateView do
  use Phoenix.Component

  import Phoenix.HTML
  import DukkadeeWeb.CoreComponents
  import DukkadeeWeb.Gettext

  # Shortcut for generating JS commands
  alias Phoenix.LiveView.JS

  # Routes generation with the ~p sigil
  use Phoenix.VerifiedRoutes,
    endpoint: DukkadeeWeb.Endpoint,
    router: DukkadeeWeb.Router,
    statics: DukkadeeWeb.static_paths()
end
