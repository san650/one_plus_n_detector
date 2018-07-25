defmodule OnePlusNDetector do
  use Application

  @moduledoc """
  Ecto Repo's logger adapter.

      config :my_app, MyApp.Repo, loggers: [
        {Ecto.LogEntry, :log, []}, # default adapter
        {OnePlusNDetector, :analyze, []}
      ]
  """

  alias OnePlusNDetector.Detector

  @impl true
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(OnePlusNDetector.Detector, []),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def analyze(%Ecto.LogEntry{query: query} = entry) do
    # We need to make sure our app is started or start it ourselves
    {:ok, _} = Application.ensure_all_started(:one_plus_n_detector)

    case Detector.check(query) do
      {:match, _query, _count} ->
        :nothing
      {:no_match, _previous_query, count} ->
        if count > 2 do
          IO.puts "---------> 1+n detected, total count: #{count}"
        end
    end

    entry
  end
end
