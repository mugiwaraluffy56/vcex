defmodule Vcex.Banner do
  def print(port) do
    IO.puts("""

    vcex running
    Local: http://localhost:#{port}
    LAN:   http://#{Vcex.Net.local_ip()}:#{port}

    SSH tunnel from guest:
    ssh -L #{port}:localhost:#{port} user@#{Vcex.Net.local_ip()}
    """)
  end
end
