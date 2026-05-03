defmodule Vcex.Net do
  def local_ip do
    {:ok, ifs} = :inet.getifaddrs()

    ifs
    |> Enum.flat_map(fn {_name, opts} -> Keyword.get_values(opts, :addr) end)
    |> Enum.find_value("127.0.0.1", fn
      {10, _, _, _} = ip -> format(ip)
      {172, b, _, _} = ip when b in 16..31 -> format(ip)
      {192, 168, _, _} = ip -> format(ip)
      _other -> nil
    end)
  end

  defp format({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
end
