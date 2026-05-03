defmodule LanCall.NetTest do
  use ExUnit.Case, async: true

  test "local_ip returns printable IPv4" do
    assert LanCall.Net.local_ip() =~ ~r/^\d+\.\d+\.\d+\.\d+$/
  end
end
