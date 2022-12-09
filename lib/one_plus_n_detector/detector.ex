defmodule OnePlusNDetector.Detector do
  @moduledoc """
  Checks a query against the previous one and increments counter of collisions or swaps previous query with the last one.
  """

  use GenServer

  # Increase counter or swaps query
  def check("SELECT" <> _rest = query) do
    do_check(query, get(query))
  end

  def check(_query) do
    nil
  end

  defp get(query) do
    Process.get("one_plus_n_detector: #{query}")
  end

  defp put(query, counter) do
    Process.put("one_plus_n_detector: #{query}", counter)
  end

  def do_check(query, nil) do
    put(query, 1)
    :first
  end

  def do_check(query, counter) do
    counter = counter + 1
    put(query, counter)
    {:match, counter}
  end

end
