defmodule DukkadeeWeb.Components.BrandColors do
  @moduledoc """
  Provides brand color definitions for the Dukkadee platform.
  This module helps maintain consistent branding across the application.
  """

  @doc """
  Primary brand colors
  """
  def primary do
    %{
      yellow: "#fddb24",
      light_purple: "#b7acd4",
      white: "#ffffff"
    }
  end

  @doc """
  Dark gray/black variations for the platform
  """
  def dark do
    %{
      darkest: "#272727",
      darker: "#282828",
      dark: "#2a2a2a",
      medium_dark: "#2c2c2c",
      medium: "#2e2e2e",
      medium_light: "#2f2f2f",
      light: "#303030",
      lighter: "#313131",
      lightest: "#323232"
    }
  end

  @doc """
  Additional dark shades
  """
  def extended_dark do
    %{
      dark_333: "#333333",
      dark_2d: "#2d2d2d",
      dark_343434: "#343434",
      dark_353535: "#353535",
      dark_363636: "#363636",
      dark_373737: "#373737",
      dark_292929: "#292929",
      dark_2b2b2b: "#2b2b2b"
    }
  end

  @doc """
  Get store specific brand colors
  Defaults to Dukkadee default colors if store doesn't have custom colors
  """
  def get_store_colors(_store_id) do
    %{
      primary: "#fddb24",
      secondary: "#b7acd4",
      dark: [
        "#272727", "#282828", "#292929", "#2a2a2a", "#2b2b2b",
        "#2c2c2c", "#2d2d2d", "#2e2e2e", "#2f2f2f", "#303030",
        "#313131", "#323232", "#333333", "#343434", "#353535",
        "#363636", "#373737"
      ]
    }
  end

  @doc """
  Get customer-specific colors, falling back to store colors if not defined.
  In the future, this will allow customers to customize their portal colors.
  """
  def get_customer_colors(_customer_id, store_id) do
    get_store_colors(store_id)
  end

  @doc """
  Generate CSS variables for all brand colors for use in templates
  """
  def css_variables do
    primary_colors = for {name, value} <- primary(), do: "--color-#{name}: #{value};"
    dark_colors = for {name, value} <- dark(), do: "--color-#{name}: #{value};"
    extended_colors = for {name, value} <- extended_dark(), do: "--color-#{name}: #{value};"
    
    Enum.join(primary_colors ++ dark_colors ++ extended_colors, "\n")
  end
end
