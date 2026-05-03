defmodule Vcex.Config do
  def client_json do
    host = System.get_env("TURN_HOST") || Vcex.Net.local_ip()
    port = System.get_env("TURN_PORT") || "3478"
    user = System.get_env("TURN_USER") || "vcex"
    password = System.get_env("TURN_PASSWORD") || "vcex-local-turn"

    """
    {
      "iceTransportPolicy": "all",
      "iceServers": [
        {
          "urls": [
            "turn:#{host}:#{port}?transport=udp",
            "turn:#{host}:#{port}?transport=tcp"
          ],
          "username": "#{escape(user)}",
          "credential": "#{escape(password)}"
        }
      ]
    }
    """
  end

  defp escape(value) do
    value
    |> String.replace("\\", "\\\\")
    |> String.replace("\"", "\\\"")
  end
end
