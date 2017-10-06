defmodule Muh.HTTP.Path do
  @moduledoc "path helpers"

  # maybe move to request path (Muh.HTTP.Request.parse_path etc)

  # @spec parse_path(:erlang.decode_packet) ::
  #       {:ok, {binary, [binary], [binary]}} | {:error, atom}
  def parse_path({:abs_path, full_path}) do
    case :binary.split(full_path, "?") do
      [url] ->
        {:ok, {full_path, split_path(url), ""}}
      [url, qs] ->
        {:ok, {full_path, split_path(url), qs}}
    end
  end
  def parse_path({:absoluteURI, _scheme, _host, _port, path}) do
    parse_path({:abs_path, path}) # maybe support scheme, host and port from here
  end
  def parse_path(_) do
    {:error, :unsupported_uri}
  end

  # @spec split_path(binary) :: [binary]
  defp split_path(path) do
    for segment <- :binary.split(path, "/", [:global]), segment !== "" do
      segment
    end
  end
end
