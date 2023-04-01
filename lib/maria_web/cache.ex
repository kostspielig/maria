defmodule MariaWeb.Cache do
  @moduledoc """
  Cache for HTTP requests.
  """

  require Logger
  alias Cachex

  @cache_name :http_cache
  @cache_ttl 12 * 60 * 60 * 1000  # 12 hours in milliseconds


   @doc """
   Fetches a URL from the cache, or make an HTTP request if it's not cached

  ## Examples

      iex> get("https://carras.co/cooking")

  """
  def get(url) do
    case Cachex.get(@cache_name, url) do
      {:ok, nil} ->
        Logger.debug("Cache miss for #{url}")
        response = make_request(url)
        Cachex.put(@cache_name, url, response, ttl: @cache_ttl)
        {:ok, response}
      {:ok, response} ->
        %HTTPoison.Response{status_code: 200, headers: headers} = response
        etag = getHeader(headers, "ETag")

        if etag do
          Task.start_link(fn ->
            case make_request(url, [{"If-None-Match", etag}]) do
              response = %HTTPoison.Response{status_code: 200, } ->
                Logger.debug("Cache hit for #{url}, found updates")
                Cachex.put(@cache_name, url, response)
              _ ->
                Logger.debug("Cache hit for #{url}, found NO updates")
                :ok
            end
          end)
        end
        Logger.debug("Cache hit for #{url}")
        {:ok, response}
    end
  end

  defp make_request(url) do
    {:ok, response} = HTTPoison.get(url)
    response
  end

  defp make_request(url, params) do
    {:ok, response} = HTTPoison.get(url, params)
    response
  end

  defp getHeader(headers, header) do
    h = Enum.find(headers, fn {x,_} -> x == header end)
    if h do
      elem(h, 1)
    else
      nil
    end
  end
end
