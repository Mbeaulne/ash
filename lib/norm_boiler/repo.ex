defmodule NormBoiler.Repo do
  use Ecto.Repo,
    otp_app: :norm_boiler,
    adapter: Ecto.Adapters.Postgres
end
