defmodule Vcex.HTTP do
  @status %{
    200 => "OK",
    400 => "Bad Request",
    404 => "Not Found",
    426 => "Upgrade Required",
    500 => "Internal Server Error"
  }

  def parse(request) do
    [head | _body] = String.split(request, "\r\n\r\n", parts: 2)
    [request_line | header_lines] = String.split(head, "\r\n")
    [method, path, _version] = String.split(request_line, " ", parts: 3)

    headers =
      Map.new(header_lines, fn line ->
        [k, v] = String.split(line, ":", parts: 2)
        {String.downcase(String.trim(k)), String.trim(v)}
      end)

    %{method: method, path: path, headers: headers}
  end

  def response(status, content_type, body) do
    header =
      "HTTP/1.1 #{status} #{Map.fetch!(@status, status)}\r\n" <>
        "content-type: #{content_type}\r\n" <>
        "content-length: #{byte_size(body)}\r\n" <>
        "connection: close\r\n\r\n"

    header <> body
  end

  def mime(path) do
    case Path.extname(path) do
      ".html" -> "text/html; charset=utf-8"
      ".css" -> "text/css; charset=utf-8"
      ".js" -> "application/javascript; charset=utf-8"
      ".json" -> "application/json; charset=utf-8"
      _ -> "application/octet-stream"
    end
  end
end
