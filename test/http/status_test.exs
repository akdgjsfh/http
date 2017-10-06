defmodule Muh.HTTP.StatusTest do
  use ExUnit.Case, async: true
  alias Muh.HTTP.Status

  test "desctiprion" do
    assert Status.description(200) == "OK"
  end

  test "full status" do
    assert Status.full_status(200) == "200 OK"
  end
end
