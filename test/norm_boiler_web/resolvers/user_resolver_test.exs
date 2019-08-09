defmodule NormBoilerWeb.UserResolverTest do
    use NormBoilerWeb.ConnCase
    
    alias NormBoiler.Auth

    describe "User Resolver" do

      @user_one %{email: "email_one@email.com", password: "123456789",  password_confirmation: "123456789",  user_name: "some_user_name_one"}
      
      def user_fixture(attrs \\ %{}, user_object) do
          {:ok, user} =
          attrs
          |> Enum.into(user_object)
          |> Auth.create_user()

          user
      end

      test "create/2 returns a JWT token" do

        mutation = """
          mutation {
              createUser(
                  email:"matt.beaulne@gmail.com",
                  password: "123456789",
                  passwordConfirmation:
                  "123456789",
                  userName: "Matt"
              ) {
                  jwt
              }
          }
        """

        response = build_conn()
        |> graphql_call(
        query: mutation,
        variables: %{}
        )

        assert response["data"]["createUser"]["jwt"]
        
      end

      test "create/2 invalid User Name" do

        mutation = """
          mutation {
            createUser(
              email:"matt.beaulne@gmail.com",
              password: "12345678",
              passwordConfirmation:
              "12345678",
            ) {
                  jwt
              }
          }
        """

        response = build_conn()
        |> graphql_call(
        query: mutation,
        variables: %{}
        )

        [head] = response["errors"]        
        assert "In argument \"userName\": Expected type \"String!\", found null." = head["message"]
        
      end

      test "create/2 invalid User credentials: Password" do

        mutation = """
          mutation {
            createUser(
              email:"matt.beaulne@gmail.com",
              password: "12345",
              passwordConfirmation: "12345",
              userName: "Matt"
            ) {
                  jwt
              }
          }
        """

        response = build_conn()
        |> graphql_call(
        query: mutation,
        variables: %{}
        )

        [first_returned_err] = response["errors"]  
        [first_err_message] = first_returned_err["message"]["password"]

        assert "should be at least 8 character(s)" = first_err_message
        
      end

      test "create/2 invalid User credentials: Password confirmation" do

        mutation = """
          mutation {
            createUser(
              email:"matt.beaulne@gmail.com",
              password: "1234567890",
              passwordConfirmation: "123456789",
              userName: "Matt"
            ) {
                  jwt
              }
          }
        """

        response = build_conn()
        |> graphql_call(
        query: mutation,
        variables: %{}
        )

        [first_returned_err] = response["errors"]  
        [first_err_message] = first_returned_err["message"]["password_confirmation"]

        assert "does not match confirmation" = first_err_message
        
      end

      test "create/2 invalid User credentials: Email" do

        mutation = """
          mutation {
            createUser(
              email:"matt.beaulnegmail.com",
              password: "1234567890",
              passwordConfirmation: "1234567890",
              userName: "Matt"
            ) {
                  jwt
              }
          }
        """

        response = build_conn()
        |> graphql_call(
        query: mutation,
        variables: %{}
        )

        [first_returned_err] = response["errors"]  
        [first_err_message] = first_returned_err["message"]["email"]

        assert "has invalid format" = first_err_message
        
      end

      test "sign_in/2 returns a JWT token" do
 
        user_fixture(@user_one)
        query = """ 
            {
              signIn(
                email: "email_one@email.com",
                password: "123456789") {
                jwt
              }
            }
        """

        response = build_conn()
        |> graphql_call(
        query: query,
        variables: %{}
        )

        assert response["data"]["signIn"]["jwt"]
        
      end

      test "update/2 updates a user" do

        user_fixture(@user_one)
        signin_query = """ 
            {
              signIn(
                email: "email_one@email.com",
                password: "123456789") {
                jwt
                userName
                id
              }
            }
        """
        update_user_mutation = """
          mutation {
            updateUser(
              email: "email_one@email.com", user_name: "some_user_name_one_new"
            ) {
              message
              }
          }
        """

        signin_response = build_conn()
          |> graphql_call(
          query: signin_query,
          variables: %{}
          )

        get_user_query = """ 
          {
            User(id: #{signin_response["data"]["signIn"]["id"]}) {
              userName
            }
          }
        """

        assert signin_response["data"]["signIn"]["userName"] == "some_user_name_one"
        token = signin_response["data"]["signIn"]["jwt"]

        update_user_response = build_conn()
          |> put_req_header("authorization", "Bearer #{token}")
          |> graphql_call(
            query: update_user_mutation,
            variables: %{}
          )

        get_user_response = build_conn()
          |> put_req_header("authorization", "Bearer #{token}")
          |> graphql_call(
            query: get_user_query,
            variables: %{}
          )

        assert update_user_response["data"]["updateUser"]["message"] == "Your account has been updated"
        assert get_user_response["data"]["User"]["userName"] == "some_user_name_one_new"

      end

    end
  end
