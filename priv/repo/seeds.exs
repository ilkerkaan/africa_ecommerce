# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dukkadee.Repo.insert!(%Dukkadee.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Dukkadee.Repo
alias Dukkadee.Accounts.User
alias Dukkadee.Stores.Store

# Create admin user with proper password hashing
{:ok, admin_user} = %User{
  email: "admin@dukkadee.com",
  is_admin: true
}
|> User.changeset(%{
  password: "password123",
  password_confirmation: "password123"
})
|> Repo.insert(on_conflict: {:replace, [:updated_at]}, conflict_target: :email)

# Create Inkless Is More store
Repo.insert!(
  %Store{
    name: "Inkless Is More",
    slug: "inklessismore-ke",
    description: "Nairobi's Premier Laser Tattoo Removal Studio",
    primary_color: "#fddb24",
    secondary_color: "#b7acd4",
    accent_color: "#272727",
    logo: "/images/inklessismore-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Create Lagos Fashion Outlet store
Repo.insert!(
  %Store{
    name: "Lagos Fashion Outlet",
    slug: "lagos-fashion",
    description: "Contemporary African fashion from Nigeria's leading designers",
    primary_color: "#00AA55",
    secondary_color: "#FF6600",
    accent_color: "#333333",
    logo: "/images/lagos-fashion-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Create Cape Town Artisans store
Repo.insert!(
  %Store{
    name: "Cape Town Artisans",
    slug: "capetown-artisans",
    description: "Handcrafted goods from South Africa's finest craftspeople",
    primary_color: "#0066CC",
    secondary_color: "#FFCC00",
    accent_color: "#222222",
    logo: "/images/capetown-artisans-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Create Accra Spice Market store
Repo.insert!(
  %Store{
    name: "Accra Spice Market",
    slug: "accra-spice",
    description: "Authentic Ghanaian spices and ingredients delivered to your door",
    primary_color: "#CC0000",
    secondary_color: "#00CC00",
    accent_color: "#2A2A2A",
    logo: "/images/accra-spice-logo.png",
    user_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Add more seed data as needed
