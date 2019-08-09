defmodule NormBoilerWeb.Schema.Schema do
    use Absinthe.Schema
    # alias NormBoiler.Auth.UserResolver
    alias NormBoilerWeb.Resolvers.UserResolver

    import_types NormBoilerWeb.Schema.Types
  
    query do
        
        @desc "Get a list of users"
        field :users, list_of(:user) do
            resolve &UserResolver.all/2
        end
    
        @desc "Get a user by its id"
        field :user, :user do
            arg :id, non_null(:id)
            resolve &UserResolver.find/2
        end

        @desc "Signs a user in"
        field :sign_in, :user do
            arg :email, non_null(:string)
            arg :password, non_null(:string)
            resolve &UserResolver.sign_in/2
        end
    end
        
    mutation do
        field :create_user, type: :user do
            arg :email, non_null(:string)
            arg :user_name, non_null(:string)
            arg :password, non_null(:string)
            arg :password_confirmation, non_null(:string)
            resolve &UserResolver.create/2
        end

        field :update_user, type: :user do
            arg :email, non_null(:string)
            arg :user_name, :string
            arg :password, :string
            arg :password_confirmation, :string
            resolve &UserResolver.update/2
        end
    end

  end