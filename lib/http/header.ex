defmodule Muh.HTTP.Header do

  # maybe move to request (Muh.HTTP.Request.get_headers etc)

  # @type header :: {key :: binary, value :: binary}
  # @type headers :: [header]

  def encode_headers([]), do: []
  def encode_headers([[] | rest]) do
    encode_headers(rest)
  end
  def encode_headers([{key, value} | rest]) do
    [encode_value(key), ": ", encode_value(value), "\r\n", encode_headers(rest)]
  end

  defp ensure_binary(bin) when is_binary(bin), do: bin
  defp ensure_binary(atom) when is_atom(atom) do
    :erlang.atom_to_binary(atom, :latin1)
  end

  defp encode_value(value) when is_binary(value), do: value
  defp encode_value(value) when is_integer(value) do
    :erlang.integer_to_binary(value)
  end
  defp encode_value(value) when is_list(value) do
    :erlang.list_to_binary(value)
  end
  defp encode_value(:keepalive), do: "keep-alive"
  defp encode_value(value) when is_atom(value) do
    :erlang.atom_to_binary(value, :latin1)
  end

  def content_length(headers, body) do
    case :proplists.is_defined("content-length", headers) do
      true -> []
      false -> {"content-length", :erlang.iolist_size(body)}
    end
  end
end
