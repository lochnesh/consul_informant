alias Experimental.GenStage
alias ConsulApi.Client

defmodule ServiceProducer do
  @moduledoc """
  A producer that gets all services from Consul
  """

  require Logger
  use GenStage

  def start_link()  do
    {services, _} = get_services()
    GenStage.start_link(__MODULE__, services, name: __MODULE__)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, services) when demand > 0 do
    {events, remainder} = Enum.split(services, demand)
    {new_services, _} = get_services()
    {:noreply, events, Enum.uniq(remainder ++ new_services)}
  end

  def get_services(), do: Client.get_all_services()

end
