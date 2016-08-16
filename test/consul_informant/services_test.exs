defmodule ServicesTest do
  use ExUnit.Case

  test "initialize service list" do
    expected_services = ['test']
    {:producer_consumer, services, opts} = Services.init(expected_services)
    assert services === expected_services
    assert opts === [subscribe_to: [{ServiceProducer, max_demand: 10, min_demand: 1}]]
  end

  test "add new services" do
    new = ["service-a", "service-b"]
    current = ["service-1", "service-2"]
    expected = current ++ new
    {:noreply, events, state} = Services.handle_events(new, "unused", current)
    assert events === expected
    assert state === expected
  end

  test "only track unique services" do
    new = ["3", "1", "2", "4"]
    current = ["2", "3", "1"]
    expected = ["2", "3", "1", "4"]
    {:noreply, events, state} = Services.handle_events(new, "u", current)
    assert events === expected
    assert state === expected
  end

end
