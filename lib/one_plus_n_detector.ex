defmodule OnePlusNDetector do
  use Application

  @moduledoc """
  Ecto Repo's logger adapter.

      config :my_app, MyApp.Repo, loggers: [
        {Ecto.LogEntry, :log, []}, # default adapter
        {OnePlusNDetector, :analyze, []}
      ]
  """

  require Logger
  alias OnePlusNDetector.Detector

  @exclude_sources ["oban_jobs", "oban_peers"]
  @exclude_queries ["commit", "begin"]
  @exclude_match ["oban_jobs", "oban_peers", "oban_insert", "pg_notify", "pg_try_advisory_xact_lock"]

  def setup(repo_module) do
    config = repo_module.config()
    prefix = config[:telemetry_prefix]
    # ^ Telemetry event id for Ecto queries
    query_event = prefix ++ [:query]

    Logger.debug "Setting up n+1 logging..."

    :telemetry.attach(
      "one_plus_n_detector",
      query_event,
      &OnePlusNDetector.handle_event/4,
      []
    )
  end

  def handle_event(
        _,
        _measurements,
        %{query: query, source: source} = _metadata,
        _config
      )
      when (is_nil(source) or source not in @exclude_sources) and
             query not in @exclude_queries do
   if not String.contains?(query, @exclude_match), do: analyze(query)
  end

  def handle_event(
        _,
        _measurements,
        _metadata,
        _config
      ) do
   # skip
  end

  def analyze(query) do
    case Detector.check(query) do
      {:match, count} ->
          Logger.warning "---------> Possible n+1 SQL query detected! number of occurrences: #{count}, query: #{query}"
      _ ->
        # no match
    end
  end
end
