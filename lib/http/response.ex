defmodule Muh.HTTP.Response do
  alias Muh.HTTP

  # maybe @compile :inline since it adds some overhead
  def build_body(method, code, resp_body) do
    case {method, code} do
      {:HEAD, _} -> []
      {_, 304} -> []
      {_, 204} -> []
      _ -> resp_body
    end
  end

  def build_headers(http_version \\ {1, 1}, resp_headers, resp_body) do
    [
      HTTP.Connection.connection(http_version, resp_headers),
      HTTP.Header.content_length(resp_headers, resp_body) | resp_headers
    ]
  end

  def build_resp(status, resp_headers, resp_body) do
    [
      "HTTP/1.1 ", status, "\r\n",
      HTTP.Header.encode_headers(resp_headers), "\r\n",
      resp_body
    ]
  end
end
