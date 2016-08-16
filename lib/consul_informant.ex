defmodule ConsulInformant do
  @moduledoc """
  Consul informat loads data from Consul and processes it
  """

  def start(_type, _args) do
    import Supervisor.Spec


    children = [
      worker(ServiceProducer, []),
      worker(ServiceDetails, []),
      worker(ServicePrinter, [])
    ]

    opts = [strategy: :one_for_one, name: ConsulInformant.Supervisor]
    Supervisor.start_link(children, opts)
  end


end
