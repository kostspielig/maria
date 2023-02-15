defmodule Maria.Repo do
  use Ecto.Repo,
    otp_app: :maria,
    adapter: Ecto.Adapters.Postgres
end
