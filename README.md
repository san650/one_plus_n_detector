# OnePlusNDetector

This library helps detect 1+n SQL queries in your application. This is a common problem when working with ORMs like Ecto.

## What is the 1+n problem?

When you have a parent-child relationship like a `has_many`, `has_one` or `belongs_to` you might load your parent records with one query and then **for each record**, trigger another SQL statment to load the related children.

Let's say you have the following Ecto schemas

```elixir
defmodule User do
  use Ecto.Schema

  schema "users" do
    has_one :details, Details
  end
end

defmodule Details do
  use Ecto.Schema

  schema "users_details" do
    belongs_to :user, User
  end
end
```

You could load all the users with its respective details the following way (**wrong way**)

```elixir
User
|> Repo.all
|> Enum.map(& %{&1 | details: Repo.get(&1.details_id)})
```

You can query all users and then for each record that it's returned you can query it's user details. This implementation falls into the 1+N problem because the first query returns N records and for each record you trigger an additional SQL query, having in total 1+N SQL queries issued to your DB.

The number of queries can be reduced to two by just using a [preload](https://hexdocs.pm/ecto/Ecto.Query.html#preload/3) statement.

```elixir
User
|> preload(:details)
|> Repo.all
```

This library helps you detect these cases by triggering a warning in your query log.

## Usage

Add an extra logger to Ecto repo in development.

```elixir
config :my_app, MyApp.Repo, loggers: [
  {OnePlusNDetector, :analyze, []},
  {Ecto.LogEntry, :log, []}
]
```

## Documentation

Documentation can be found at [https://hexdocs.pm/one_plus_n_detector](https://hexdocs.pm/one_plus_n_detector).

## Installation

**This library should be used only on development**

```elixir
def deps do
  [
    {:one_plus_n_detector, "~> 0.1.0", only: :dev}
  ]
end
```

Remember to **not add** `:one_plus_n_detector` to your applications list!

## License

one_plus_n_detector is licensed under the MIT license.

See [LICENSE](./LICENSE) for the full license text.
