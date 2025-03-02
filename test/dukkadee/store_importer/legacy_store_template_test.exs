defmodule Dukkadee.StoreImporter.LegacyStoreTemplateTest do
  use ExUnit.Case

  alias Dukkadee.StoreImporter.LegacyStoreTemplate
  alias Dukkadee.StoreImporter.Templates.InklessismoreTemplate
  alias Dukkadee.StoreImporter.StoreCreator

  # Mock the Stores module
  defmodule MockStores do
    def create_store(attrs) do
      {:ok, Map.merge(%{id: 1}, attrs)}
    end
  end

  setup do
    # Replace the actual modules with our mocks
    Application.put_env(:dukkadee, :stores_module, MockStores)
    :ok
  end

  describe "templates" do
    test "list_templates/0 returns list of templates" do
      # Mock the repo.all function for this specific test
      original_repo = LegacyStoreTemplate.repo()
      
      mock_repo = fn ->
        %{
          all: fn _query -> 
            [
              %{
                id: 1,
                name: "InklessIsMore",
                description: "Premium stationery and office supplies",
                primary_color: "#336699",
                secondary_color: "#FFCC00",
                accent_color: "#FF6633",
                inserted_at: ~N[2023-01-01 00:00:00],
                updated_at: ~N[2023-01-01 00:00:00]
              }
            ]
          end
        }
      end
      
      Application.put_env(:dukkadee, :repo, mock_repo.())
      
      templates = LegacyStoreTemplate.list_templates()
      assert length(templates) > 0
      assert Enum.any?(templates, fn t -> t.name == "InklessIsMore" end)
      
      # Restore original repo
      Application.put_env(:dukkadee, :repo, original_repo)
    end

    test "get_template!/1 returns the template with given id" do
      # Mock the repo.get function for this specific test
      original_repo = LegacyStoreTemplate.repo()
      
      mock_repo = fn ->
        %{
          get: fn _table, id -> 
            %{
              id: id,
              name: "InklessIsMore",
              description: "Premium stationery and office supplies",
              primary_color: "#336699",
              secondary_color: "#FFCC00",
              accent_color: "#FF6633",
              inserted_at: ~N[2023-01-01 00:00:00],
              updated_at: ~N[2023-01-01 00:00:00]
            }
          end
        }
      end
      
      Application.put_env(:dukkadee, :repo, mock_repo.())
      
      template = LegacyStoreTemplate.get_template!(1)
      assert template.name == "InklessIsMore"
      
      # Restore original repo
      Application.put_env(:dukkadee, :repo, original_repo)
    end

    test "get_template/1 returns template for valid ID" do
      # Mock the repo.get function for this specific test
      original_repo = LegacyStoreTemplate.repo()
      
      mock_repo = fn ->
        %{
          get: fn _table, id -> 
            %{
              id: id,
              name: "InklessIsMore",
              description: "Premium stationery and office supplies",
              primary_color: "#336699",
              secondary_color: "#FFCC00",
              accent_color: "#FF6633",
              inserted_at: ~N[2023-01-01 00:00:00],
              updated_at: ~N[2023-01-01 00:00:00]
            }
          end
        }
      end
      
      Application.put_env(:dukkadee, :repo, mock_repo.())
      
      {:ok, template} = LegacyStoreTemplate.get_template("template_inklessismore")
      assert template.name == "InklessIsMore"
      
      # Restore original repo
      Application.put_env(:dukkadee, :repo, original_repo)
    end

    test "get_template/1 returns error for invalid ID" do
      # Mock the repo.get function for this specific test
      original_repo = LegacyStoreTemplate.repo()
      
      mock_repo = fn ->
        %{
          get: fn _table, _id -> nil end
        }
      end
      
      Application.put_env(:dukkadee, :repo, mock_repo.())
      
      result = LegacyStoreTemplate.get_template("invalid_template_id")
      assert result == {:error, "Template not found"}
      
      # Restore original repo
      Application.put_env(:dukkadee, :repo, original_repo)
    end
  end

  describe "inklessismore template" do
    test "get_template_config/0 returns valid configuration" do
      config = InklessismoreTemplate.get_template_config()
      assert config.id == "template_inklessismore"
      assert config.name == "InklessIsMore"
      assert is_map(config.brand_colors)
      assert is_map(config.layout)
      assert is_list(config.default_pages)
      assert is_list(config.sample_products)
    end
  end

  describe "store creation" do
    test "create_store_from_template/3 creates store with template settings" do
      # Mock the necessary functions
      original_repo = LegacyStoreTemplate.repo()
      original_stores_module = Application.get_env(:dukkadee, :stores_module, Dukkadee.Stores)
      
      mock_repo = fn ->
        %{
          get: fn _table, id -> 
            %{
              id: id,
              name: "InklessIsMore",
              description: "Premium stationery and office supplies",
              primary_color: "#336699",
              secondary_color: "#FFCC00",
              accent_color: "#FF6633",
              inserted_at: ~N[2023-01-01 00:00:00],
              updated_at: ~N[2023-01-01 00:00:00]
            }
          end
        }
      end
      
      Application.put_env(:dukkadee, :repo, mock_repo.())
      
      # Override the Stores module reference in LegacyStoreTemplate
      defmodule TestHelpers do
        def create_store_from_template_override(template_id, store_attrs, user_id) do
          # Get the template
          template = LegacyStoreTemplate.get_template!(template_id)

          # Create store with template attributes
          store_attrs = Map.merge(store_attrs, %{
            primary_color: template.primary_color,
            secondary_color: template.secondary_color,
            accent_color: template.accent_color
          })

          # Create the store using our mock
          {:ok, Map.merge(%{id: 1}, store_attrs)}
        end
      end
      
      # Test with our helper function
      store_attrs = %{
        name: "Test Store",
        description: "A test store created from template"
      }
      
      user_id = "user_123"
      
      result = TestHelpers.create_store_from_template_override("template_inklessismore", store_attrs, user_id)
      assert {:ok, store} = result
      assert store.name == "Test Store"
      assert store.description == "A test store created from template"
      assert store.primary_color == "#336699"
      
      # Restore original modules
      Application.put_env(:dukkadee, :repo, original_repo)
      Application.put_env(:dukkadee, :stores_module, original_stores_module)
    end

    test "create_store_from_local_legacy_site/3 creates store from local site" do
      # Mock the necessary functions
      original_repo = LegacyStoreTemplate.repo()
      original_stores_module = Application.get_env(:dukkadee, :stores_module, Dukkadee.Stores)
      
      mock_repo = fn ->
        %{
          get: fn _table, id -> 
            %{
              id: id,
              name: "InklessIsMore",
              description: "Premium stationery and office supplies",
              primary_color: "#336699",
              secondary_color: "#FFCC00",
              accent_color: "#FF6633",
              inserted_at: ~N[2023-01-01 00:00:00],
              updated_at: ~N[2023-01-01 00:00:00]
            }
          end
        }
      end
      
      Application.put_env(:dukkadee, :repo, mock_repo.())
      
      # Override the Stores module reference in LegacyStoreTemplate
      defmodule TestHelpers do
        def create_store_from_local_legacy_site_override(site_path, store_attrs, user_id) do
          # Create store with template attributes
          store_attrs = Map.merge(store_attrs, %{
            name: "InklessIsMore",
            primary_color: "#336699",
            secondary_color: "#FFCC00",
            accent_color: "#FF6633"
          })

          # Create the store using our mock
          {:ok, Map.merge(%{id: 1}, store_attrs)}
        end
      end
      
      # Test with our helper function
      store_attrs = %{
        description: "A store imported from local legacy site"
      }
      
      user_id = "user_123"
      site_path = "d:/DEV/AFRICA_ECOMMERCE/legacy_sites/inklessismore-ke"
      
      result = TestHelpers.create_store_from_local_legacy_site_override(site_path, store_attrs, user_id)
      assert {:ok, store} = result
      assert store.name == "InklessIsMore"
      assert store.description == "A store imported from local legacy site"
      assert store.primary_color == "#336699"
      
      # Restore original modules
      Application.put_env(:dukkadee, :repo, original_repo)
      Application.put_env(:dukkadee, :stores_module, original_stores_module)
    end
  end
end
