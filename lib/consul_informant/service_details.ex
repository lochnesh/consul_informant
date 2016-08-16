alias Experimental.GenStage
alias ConsulApi.Client

defmodule ServiceDetails do
  @moduledoc """
  A producer_consumer that gets the details for a service from Consul
  """

  require Logger
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(state) do
    {
      :producer_consumer,
      state,
      subscribe_to: [Services]
    }
  end

  def handle_events(events, _from, state) do
    Logger.debug("got events = #{events}")
    services = Enum.map(events, &({&1, Client.get_services(&1)}))
    Logger.debug("#{inspect services}")
    {:noreply, services, state}
  end

end
