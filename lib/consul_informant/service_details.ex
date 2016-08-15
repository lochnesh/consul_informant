alias Experimental.GenStage

defmodule ServiceDetails do
  require Logger
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, 0, name: __MODULE__)
  end

  def init(consul_index) do
    {:producer_consumer, consul_index, subscribe_to: [{ServiceProducer, max_demand: 1}]}
  end

  def handle_events(events, _from, consul_index) do
    Logger.info("got events = #{events}")
    services = Enum.map(events, fn(x) -> ConsulApi.Client.get_services(x, consul_index) end)
    Logger.info("#{inspect services}")
    {:noreply, [services], consul_index}
  end

end
