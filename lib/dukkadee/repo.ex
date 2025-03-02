defmodule Dukkadee.Repo do
  use Ecto.Repo,
    otp_app: :dukkadee,
    adapter: Ecto.Adapters.Postgres
end
