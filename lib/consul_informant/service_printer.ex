alias Experimental.GenStage

defmodule ServicePrinter do
  @moduledoc """
  A consumer that prints the details of a service
  """

  require Logger
  use GenStage

  def start_link()  do
    GenStage.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    {:consumer, :ok, subscribe_to: [ServiceDetails]}
  end

  def handle_events(events, _from, state) do
    Logger.debug("received #{inspect events}")

    {:noreply, [], state}
  end

end
