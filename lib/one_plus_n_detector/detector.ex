defmodule OnePlusNDetector.Detector do
  @moduledoc """
  Checks a query against the previous one and increments counter of collisions or swaps previous query with the last one.
  """

  use GenServer

  # Increase counter or swaps query
  def check("SELECT" <> _rest = query) do
    GenServer.call(__MODULE__, {:check, query})
  end

  def check(_query) do
    GenServer.call(__MODULE__, :reset)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{query: nil, counter: 0}, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:check, query}, _from, %{query: query, counter: counter} = state) do
    {:reply, {:match, query, counter + 1}, Map.put(state, :counter, counter + 1)}
  end

  @impl true
  def handle_call({:check, query}, _from, %{query: previous_query, counter: previous_count}) do
    {:reply, {:no_match, previous_query, previous_count}, %{query: query, counter: 1}}
  end

  @impl true
  def handle_call(:reset, _from, %{query: previous_query, counter: previous_count}) do
    {:reply, {:no_match, previous_query, previous_count}, %{query: nil, counter: 0}}
  end
end
