defmodule NormBoiler.AuthTest do
  use NormBoiler.DataCase

  alias NormBoiler.Auth

  describe "users" do
    alias NormBoiler.Auth.User

    @valid_attrs %{email: "email@email.com", password: "123456789",  password_confirmation: "123456789",  user_name: "some_user_name"}
    @update_attrs %{email: "email_updated@email.com", password: "some_updated_password", user_name: "some_updated_user_name"}
    @invalid_attrs %{email: nil, password: nil,  password_confirmation: nil,  user_name: nil}
    @invalid_update_attrs %{email: "email.email.com", user_name: ""}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Auth.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      [first_db_user] = Auth.list_users()
      
      assert first_db_user.email == user.email
      assert first_db_user.user_name == user.user_name
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      db_user = Auth.get_user!(user.id)

      assert db_user.email == user.email
      assert db_user.user_name == user.user_name
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "email@email.com"
      assert user.password == "123456789"
      assert user.user_name == "some_user_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Auth.update_user(user, @update_attrs)
      assert user.email == "email_updated@email.com"
      assert user.password == "some_updated_password"
      assert user.user_name == "some_updated_user_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_update_attrs)
      db_user = Auth.get_user!(user.id)
      assert user.email == db_user.email
      assert user.id == db_user.id
      assert user.user_name == db_user.user_name
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
