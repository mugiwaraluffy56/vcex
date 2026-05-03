turnserver =
  System.find_executable("turnserver") ||
    raise "turnserver not found. Install coturn first: brew install coturn"

Kernel.ParallelCompiler.compile(Path.wildcard("lib/**/*.ex"), return_diagnostics: true)

args = [
  "-c",
  "turnserver.conf",
  "--external-ip",
  Vcex.Net.local_ip()
]

IO.puts("Starting TURN on #{Vcex.Net.local_ip()}:3478")
System.cmd(turnserver, args, into: IO.stream())
