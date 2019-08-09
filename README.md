# NormBoiler

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Start Docker `docker-compose up`
- Create and migrate your database with `mix ecto.setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can start making api (GraphQL) calls to [`localhost:4000/api`](http://localhost:4000/api)

or you can visit [`localhost:4000/graphiql`](http://localhost:4000/graphiql) from your browser to view the schema and start writing request

Creating a record using the GraphQL schema looks a little like:

```
mutation{
  createUser(email: "matt.beaulne123@gmail.com", password: "123456789", passwordConfirmation: "123456789", userName: "Matthews") {
      jwt
  }
}
```

Quering the api would look something like this:

```
query {
  users {
    id,
    email
  }
}
```

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: http://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Mailing list: http://groups.google.com/group/phoenix-talk
- Source: https://github.com/phoenixframework/phoenix
