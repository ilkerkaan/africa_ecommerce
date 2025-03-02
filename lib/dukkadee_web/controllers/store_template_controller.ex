defmodule DukkadeeWeb.StoreTemplateController do
  use DukkadeeWeb, :controller

  alias Dukkadee.StoreImporter.LegacyStoreTemplate
  alias Dukkadee.StoreImporter.StoreCreator
  alias Dukkadee.Stores
  alias DukkadeeWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    templates = LegacyStoreTemplate.list_templates()
    render(conn, "index.html", templates: templates)
  end

  def show(conn, %{"id" => template_id}) do
    case LegacyStoreTemplate.get_template(template_id) do
      {:ok, template} ->
        render(conn, "show.html", template: template)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Template not found")
        |> redirect(to: Routes.store_template_path(conn, :index))
    end
  end

  def new(conn, %{"template_id" => template_id}) do
    case LegacyStoreTemplate.get_template(template_id) do
      {:ok, template} ->
        changeset = Stores.Store.changeset(%Stores.Store{}, %{})
        render(conn, "new.html", changeset: changeset, template: template)
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Template not found")
        |> redirect(to: Routes.store_template_path(conn, :index))
    end
  end

  def create(conn, %{"store" => store_params, "template_id" => template_id}) do
    current_user = conn.assigns.current_user

    case StoreCreator.create_store_from_template(template_id, store_params, current_user.id) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store created successfully from template.")
        |> redirect(to: Routes.store_path(conn, :show, store))
      {:error, %Ecto.Changeset{} = changeset} ->
        {:ok, template} = LegacyStoreTemplate.get_template(template_id)
        render(conn, "new.html", changeset: changeset, template: template)
    end
  end

  def import_legacy(conn, _params) do
    render(conn, "import_legacy.html")
  end

  def create_from_legacy(conn, %{"legacy_site" => %{"path" => path, "store_name" => name}}) do
    current_user = conn.assigns.current_user
    store_attrs = %{name: name}

    case StoreCreator.create_store_from_local_legacy_site(path, store_attrs, current_user.id) do
      {:ok, store} ->
        conn
        |> put_flash(:info, "Store created successfully from legacy site.")
        |> redirect(to: Routes.store_path(conn, :show, store))
      {:error, reason} ->
        conn
        |> put_flash(:error, "Failed to create store: #{reason}")
        |> render("import_legacy.html")
    end
  end
end
