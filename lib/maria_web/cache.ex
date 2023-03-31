defmodule MariaWeb.Cache do
  @moduledoc """
  Cache for HTTP requests.
  """

  require Logger
  alias Cachex

  @cache_name :http_cache
  @cache_ttl 12 * 60 * 60 * 1000  # 12 hours in milliseconds
  # @cache_capacity 10_000          # maximum number of items in cache


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
      {:ok, value} ->
        Logger.debug("Cache hit for #{url}")
        {:ok, value}
    end
  end

  defp make_request(url) do
    {:ok, response} = HTTPoison.get(url)
    response
  end
end
