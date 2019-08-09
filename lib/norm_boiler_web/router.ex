defmodule NormBoilerWeb.Router do
  use NormBoilerWeb, :router

  pipeline :graphql do
    plug NormBoilerWeb.Plugs.AuthPlug
   end

  scope "/" do
    pipe_through :graphql

    forward "/api", Absinthe.Plug,
      schema: NormBoilerWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NormBoilerWeb.Schema.Schema,
      interface: :simple
  end
end
