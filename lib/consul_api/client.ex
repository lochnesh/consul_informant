defmodule ConsulApi.Client do
  @moduledoc """
  Functions that call the Consul api
  """

  @timeout 30_000

  def get_all_services(index \\ 0) do
    response = call_consul("/v1/catalog/services?index=#{index}&wait=25s")
    index = get_index(response)
    json = JSX.decode!(response.body)
    {Map.keys(json), index}
  end

  def get_services(service, index \\ 0) do
    service_url = "/v1/health/service/#{service}"
    params = "?passing=true&index=#{index}&wait=25s"
    response = call_consul("#{service_url}#{params}")
    JSX.decode!(response.body)
  end

  defp call_consul(path) do
    HTTPoison.start
    {:ok, response} = HTTPoison.get(
      "#{consul_url()}#{path}",
      [],
      [{:timeout, @timeout}, {:recv_timeout, @timeout}, hackney: [:insecure]])
    response
  end

  defp get_index(response) do
    {"X-Consul-Index", index} = Enum.find(response.headers, fn(x) ->
      case x do
        {"X-Consul-Index", _} -> true
        _ -> false
      end
    end)
    index
  end

  defp consul_url() do
    System.get_env("CONSUL_URL")
  end

end
