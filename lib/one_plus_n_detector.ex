defmodule OnePlusNDetector do
  @moduledoc """
  Ecto Repo's logger adapter.

      config :my_app, MyApp.Repo, loggers: [
        {Ecto.LogEntry, :log, []}, # default adapter
        {OnePlusNDetector, :analyze, []}
      ]
  """

  alias OnePlusNDetector.Detector

  def analyze(%Ecto.LogEntry{query: query} = entry) do
    case Detector.check(query) do
      {:match, _query, _count} ->
        :nothing
      {:no_match, previous_query, count} ->
        if count > 2 do
          IO.puts "---------> 1+n detected, total count: #{count}"
        end
    end

    entry
  end
end
