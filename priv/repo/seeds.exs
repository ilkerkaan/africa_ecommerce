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

# Create admin user
Repo.insert!(
  %User{
    email: "admin@dukkadee.com",
    password_hash: Bcrypt.hash_pwd_salt("admin123"),
    is_admin: true
  },
  on_conflict: :nothing
)

# Add more seed data as needed
