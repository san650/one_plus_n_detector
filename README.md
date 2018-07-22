# OnePlusNDetector

This library helps detect 1 + n queries in your application. This is a common problem when working with ORMs like Ecto.

## Usage

Add an extra logger to Ecto repo.

```elixir
config :my_app, MyApp.Repo, loggers: [
  {OnePlusNDetector, :analyze, []},
  {Ecto.LogEntry, :log, []}
]
```

And then configure this library's GenServer in your application

```elixir
def start(_type, _args) do
  import Supervisor.Spec, warn: false

  children = [
    supervisor(MyApp.Endpoint, []),
    supervisor(MyApp.Repo, []),
    worker(OnePlusNDetector.Detector, []),
  ]

  opts = [strategy: :one_for_one, name: MyApp.Supervisor]
  Supervisor.start_link(children, opts)
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/one_plus_n_detector](https://hexdocs.pm/one_plus_n_detector).

## Installation

```elixir
def deps do
  [
    {:one_plus_n_detector, "~> 0.1.0"}
  ]
end
```

## License

one_plus_n_detector is licensed under the MIT license.

See [LICENSE](./LICENSE) for the full license text.
