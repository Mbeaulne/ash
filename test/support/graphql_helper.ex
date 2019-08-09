defmodule NormBoiler.GraphQLHelper do
  use Phoenix.ConnTest

  @endpoint NormBoilerWeb.Endpoint

  def graphql_call(conn, options) do
    conn
    |> post("/api", call_skeleton(options[:query], options[:variables]))
    |> json_response(200)
  end

  defp call_skeleton(query, variables) do
    %{
      "query" => query,
      "variables" => variables
    }
  end
end