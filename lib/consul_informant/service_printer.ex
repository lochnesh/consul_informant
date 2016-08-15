alias Experimental.GenStage

defmodule ServicePrinter do
  require Logger
  use GenStage

  def start_link()  do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [{ServiceDetails, max_demand: 1}]}
  end

  def handle_events(events, _from, state) do
    :timer.sleep(1000)

    Logger.info("received #{inspect events}")

    {:noreply, [], state}
  end

end
