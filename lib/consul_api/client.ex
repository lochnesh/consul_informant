defmodule ConsulApi.Client do
  @timeout 30000

  def get_all_services(index \\ 0) do
    HTTPoison.start
    {:ok, response} = HTTPoison.get(
     "#{consul_url()}/v1/catalog/services?index=#{index}&wait=25s",
     [],
     [{:timeout, @timeout}, {:recv_timeout, @timeout}, hackney: [:insecure]])

    index = get_index(response)
    json = JSX.decode!(response.body)
    {Map.keys(json), index}
  end

  def get_services(service, index \\ 0) do 
    HTTPoison.start
    {:ok, response} = HTTPoison.get(
    "#{consul_url()}/v1/health/service/#{service}?passing=true&index=#{index}&wait=25s",
    [],
    [{:timeout, @timeout}, {:recv_timeout, @timeout}, hackney: [:insecure]])
    JSX.decode!(response.body)
  end

  defp consul_url() do
    System.get_env("CONSUL_URL")
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

end
