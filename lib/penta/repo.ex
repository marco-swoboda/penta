defmodule Penta.Repo do
  use Ecto.Repo,
    otp_app: :penta,
    adapter: Ecto.Adapters.Postgres
end
