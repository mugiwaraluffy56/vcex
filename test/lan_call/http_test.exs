defmodule LanCall.HTTPTest do
  use ExUnit.Case, async: true

  test "parses request line and headers" do
    request = "GET /ws HTTP/1.1\r\nHost: localhost\r\nUpgrade: websocket\r\n\r\n"

    assert %{
             method: "GET",
             path: "/ws",
             headers: %{"host" => "localhost", "upgrade" => "websocket"}
           } = LanCall.HTTP.parse(request)
  end

  test "builds response" do
    response = LanCall.HTTP.response(200, "text/plain", "ok")
    assert response =~ "HTTP/1.1 200 OK"
    assert response =~ "content-length: 2"
  end
end
