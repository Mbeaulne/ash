defmodule NormBoilerWeb.AuthPlugTest do
    use NormBoilerWeb.ConnCase
  
    alias NormBoiler.Auth

    describe "Auth Plug" do

        @user_one %{email: "email_one@email.com", password: "123456789",  password_confirmation: "123456789",  user_name: "some_user_name_one"}
        @user_two %{email: "email_two@email.com", password: "123456789",  password_confirmation: "123456789",  user_name: "some_user_name_two"}
        
        def user_fixture(attrs \\ %{}, user_object) do
            {:ok, user} =
            attrs
            |> Enum.into(user_object)
            |> Auth.create_user()

            user
        end

        test "create/2 returns a JWT token" do

            user_one = user_fixture(@user_one)
            user_two = user_fixture(@user_two)

            query = """
                query {
                    users {
                        id,
                        email
                    }
                }
            """
            response = build_conn()
                |> put_req_header("authorization", "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJub3JtX2JvaWxlciIsImV4cCI6MTU2MjM2ODcxMywiaWF0IjoxNTU5OTQ5NTEzLCJpc3MiOiJub3JtX2JvaWxlciIsImp0aSI6IjY5NGRjNGVlLWRiYmMtNDJkZi04OGY5LTYyOTZjMjBiZDJhNSIsIm5iZiI6MTU1OTk0OTUxMiwic3ViIjoiNiIsInR5cCI6ImFjY2VzcyJ9.iPn3x3k1WE2FcPEejo5utrSqGPOaDE_ZbOGYq4Pp0tROQu9mQlC76RZdgqNSef60C6vfFRu6yHgH8kymtAMU5g")
                |> graphql_call(
                    query: query,
                    variables: %{}
                )

            assert length(response["data"]["users"]) == 2

            [first_user | tail] = response["data"]["users"]
            [second_user] = tail

            assert first_user["email"] == user_one.email
            assert second_user["email"] == user_two.email

        end
    end
end
