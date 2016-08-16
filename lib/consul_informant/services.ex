alias Experimental.GenStage

defmodule Services do
  @moduledoc """
  A prodcuer_consumer that maintains a list of services
  """

  require Logger
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(services) do
    {
      :producer_consumer,
      services,
      subscribe_to: [{ServiceProducer, max_demand: 1}]
    }
  end

  def handle_events(events, _from, services) do
    services = Enum.uniq(services ++ events)
    {:noreply, services, services}
  end

end
