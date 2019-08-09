defmodule NormBoilerWeb.Schema.Types do
    use Absinthe.Schema.Notation
  
    object :user do
      field :id, :id
      field :user_name, :string
      field :email, :string
      field :password, :string
      field :password_confirmation, :string
      field :jwt, :string
      field :message, :string
    end
  end