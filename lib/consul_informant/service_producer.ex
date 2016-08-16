alias Experimental.GenStage
alias ConsulApi.Client

defmodule ServiceProducer do
  @moduledoc """
  A producer that gets all services from Consul
  """

  require Logger
  use GenStage

  def start_link()  do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(index) do
    {:producer, index}
  end

  def handle_demand(demand, index) when demand > 0 do
    {services, new_index} = get_services(index)
    {:noreply, services, new_index}
  end

  def get_services(index), do: Client.get_all_services(index)

end
