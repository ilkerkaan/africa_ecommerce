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

# Create admin user
admin_user = Repo.insert!(
  %User{
    email: "admin@dukkadee.com",
    password_hash: "temporary_hash_for_development", # This is just for development, in production use proper hashing
    is_admin: true
  },
  on_conflict: :nothing
)

# Create Inklessismore store
Repo.insert!(
  %Store{
    name: "Inkless Is More",
    slug: "inklessismore-ke",
    description: "Nairobi's Premier Laser Tattoo Removal Studio",
    primary_color: "#fddb24",
    secondary_color: "#b7acd4",
    accent_color: "#272727",
    logo_url: "/images/inklessismore-logo.png",
    owner_id: admin_user.id
  },
  on_conflict: :replace_all,
  conflict_target: :slug
)

# Add more seed data as needed
