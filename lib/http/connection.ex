defmodule Muh.HTTP.Connection do

  # @type token :: :keepalive | :close

  # @spec close_or_keepalive(Elli.HTTP.Request.t, Plug.Conn.t) :: token
  def close_or_keepalive(version, %{resp_headers: resp_headers, req_headers: req_headers}) do
    case :proplists.get_value("connection", resp_headers) do
      :undefined -> connection_token(version, req_headers)
      "close" -> :close
      "keep-alive" -> :keepalive
    end
  end

  @doc "Adds appropriate connection header if the user did not add one already."
  # @spec connection({1, 1} | {1, 0} | {0, 9}, Plug.Conn.headers) :: {"connection", token} | []
  def connection(version, resp_headers) do
    case :proplists.get_value("connection", resp_headers) do
      :undefined -> {"connection", connection_token(version, resp_headers)}
      _ -> []
    end
  end


  # @spec connection_token(Elli.HTTP.Request.t, Plug.Conn.headers) :: token
  defp connection_token({1, 1}, headers) do
    case :proplists.get_value("connection", headers) do
      "close" -> :close
      _ -> :keepalive
    end
  end
  defp connection_token({1, 0}, headers) do
    case :proplists.get_value("connection", headers) do
      "keep-alive" -> :keepalive
      _ -> :close
    end
  end
  defp connection_token({0, 9}, _headers) do
    :close
  end
end
