host = System.get_env("CALL_HOST") || "user@lan-host"
port = System.get_env("CALL_PORT") || "4000"

IO.puts("""
Run from guest machine:

ssh -L #{port}:localhost:#{port} #{host}

Then open:
http://localhost:#{port}
""")
