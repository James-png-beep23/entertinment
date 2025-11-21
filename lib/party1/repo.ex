defmodule Party1.Repo do
  use Ecto.Repo,
    otp_app: :party1,
    adapter: Ecto.Adapters.Postgres
end
