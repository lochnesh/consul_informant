alias Experimental.GenStage

defmodule ServiceHealth do
  @moduledoc """
  A consumer that tracks service health
  """

  require Logger
  use GenStage

  def start_link() do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    {:consumer, state, subscribe_to: [ServiceDetails]}
  end

  def handle_events(events, _from, state) do
    {
      :noreply,
      [],
      events |> Enum.reduce(state, &(process_service(&1, &2)))
    }
  end

  defp process_service({service, details}, state) do
    healthy_count = Enum.count(details)
    {current, time} = Map.get(state, service, {nil, nil})

    if current == healthy_count do
      Logger.debug "#{service} : healthy count has not changed"
      state
    else
      time = get_time()
      {prior, new_state} = Map.get_and_update(
        state,
        service,
        &({&1, {healthy_count, time}}))
      case prior do
        nil -> Logger.info "#{service} : set initial count to #{healthy_count}"
        {old_value, old_time} -> log_change(
          service,
          old_value,
          old_time,
          healthy_count,
          time)
      end
      new_state
    end
  end

  defp get_time() do
    System.system_time(:seconds)
  end

  @lint {Credo.Check.Readability.MaxLineLength, false}
  defp log_change(service, prior_count, prior_time, current, time) do
    message = "#{service} : healthy count changed from #{prior_count} to #{current} has been #{time - prior_time} seconds since last change"
    if current == 0 do
      Logger.error "#{service} : No healthy instances"
    end
    if prior_count > current do
      Logger.warn message
    else
      Logger.info message
    end
  end

end
