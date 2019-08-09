defmodule NormBoilerWeb.Resolvers.UserResolver do
    
    alias NormBoiler.Auth
    alias NormBoiler.Auth.User
    alias NormBoiler.Guardian
    alias NormBoiler.Repo
    
    import NormBoilerWeb.ErrorHelpers
    import Ecto.Changeset

    def all(_args, %{context: %{current_user: _current_user}}) do
      {:ok, Auth.list_users()}
    end

    def all(_args, _info) do
      {:error, "Not Authorized"}
    end
  
    def find(%{id: id},  %{context: %{current_user: _current_user}}) do
      case Auth.get_user!(id) do
        nil -> {:error, "User id #{id} not found!"}
        user -> {:ok, user}
      end
    end

    def find(_args, _info) do
      {:error, "Not Authorized"}
    end
    
    def sign_in(%{email: email, password: password}, _info) do
      with {:ok, token, _claims} <- Auth.token_sign_in(email, password),
          {:ok, %User{} = user} <- Auth.get_by_email(email) do
          {:ok, Map.merge(%{jwt: token}, user)}
      else
        {:error, changeset} -> {:error, "Not Authorizedz"}
      end
    end

    def create(args, _info) do
        with {:ok, %User{} = user} <- Auth.create_user(args),
            {:ok, token, _full_claims} <- Guardian.encode_and_sign(user) do
            {:ok, %{jwt: token}}
          else
            {:error, changeset} -> {:error, message: traverse_errors(changeset, &translate_error/1)}
        end
    end

  def update(args, %{context: %{current_user: current_user}}) do
    with  {:ok, %User{} = userbyEmail} <- Auth.get_by_email(args.email),
    {:ok, %User{} = userbyEmail} <- Auth.update_user(userbyEmail, args) do
      {:ok, %{message: "Your account has been updated"}}
    else
      {:error, update} -> {:error, "Your account has not been updated"}
    end
  end

  def update(_args, _info) do
    {:error, "Not Authorized"}
  end


end
