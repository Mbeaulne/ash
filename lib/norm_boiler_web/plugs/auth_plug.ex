defmodule NormBoilerWeb.Plugs.AuthPlug do
  @behaviour Plug

  import Plug.Conn
  alias NormBoiler.Guardian
  alias NormBoiler.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
      {:ok, current_user} <- authorize(token) do
        %{current_user: current_user}
      else
        _ -> %{}
      end
  end

  defp authorize(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, user } ->
        {:ok, user}
      _ ->
        {:error, :unauthorized}
    end
  end
end