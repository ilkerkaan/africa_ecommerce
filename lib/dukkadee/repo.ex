defmodule Dukkadee.Repo do
  use Ecto.Repo,
    otp_app: :dukkadee,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 12
end
