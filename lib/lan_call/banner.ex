defmodule LanCall.Banner do
  def print(port) do
    IO.puts("""

    LAN Call running
    Local: http://localhost:#{port}
    LAN:   http://#{LanCall.Net.local_ip()}:#{port}

    SSH tunnel from guest:
    ssh -L #{port}:localhost:#{port} user@#{LanCall.Net.local_ip()}
    """)
  end
end
