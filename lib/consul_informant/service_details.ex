alias Experimental.GenStage
alias ConsulApi.Client

defmodule ServiceDetails do
  @moduledoc """
  A producer_consumer that gets the details for a service from Consul
  """

  require Logger
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(consul_index) do
    {
      :producer_consumer,
      consul_index,
      subscribe_to: [{ServiceProducer, max_demand: 1}]
    }
  end

  def handle_events(events, _from, consul_index) do
    Logger.info("got events = #{events}")
    services = Enum.map(events, &(Client.get_services(&1, consul_index)))
    Logger.info("#{inspect services}")
    {:noreply, [services], consul_index}
  end

end
