defmodule Vcex.WebSocket do
  @magic "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

  def accept_key(key) do
    :crypto.hash(:sha, key <> @magic)
    |> Base.encode64()
  end

  def handshake(headers) do
    key = Map.fetch!(headers, "sec-websocket-key")

    """
    HTTP/1.1 101 Switching Protocols\r
    Upgrade: websocket\r
    Connection: Upgrade\r
    Sec-WebSocket-Accept: #{accept_key(key)}\r
    \r
    """
  end

  def encode_text(text) when byte_size(text) < 126 do
    <<0x81, byte_size(text)>> <> text
  end

  def encode_text(text) when byte_size(text) < 65_536 do
    <<0x81, 126, byte_size(text)::16>> <> text
  end

  def decode_frame(<<_fin::1, _rsv::3, opcode::4, 1::1, len::7, mask::binary-4, rest::binary>>)
      when len < 126 do
    if byte_size(rest) >= len do
      <<payload::binary-size(len), tail::binary>> = rest
      {:ok, opcode, unmask(payload, mask), tail}
    else
      :more
    end
  end

  def decode_frame(
        <<_fin::1, _rsv::3, opcode::4, 1::1, 126::7, len::16, mask::binary-4, rest::binary>>
      ) do
    if byte_size(rest) >= len do
      <<payload::binary-size(len), tail::binary>> = rest
      {:ok, opcode, unmask(payload, mask), tail}
    else
      :more
    end
  end

  def decode_frame(<<_fin::1, _rsv::3, _opcode::4, 1::1, 127::7, _rest::binary>>) do
    {:error, :frame_too_large}
  end

  def decode_frame(_frame), do: :more

  defp unmask(payload, mask) do
    mask_bytes = :binary.bin_to_list(mask)

    payload
    |> :binary.bin_to_list()
    |> Enum.with_index()
    |> Enum.map(fn {byte, idx} -> bxor(byte, Enum.at(mask_bytes, rem(idx, 4))) end)
    |> :binary.list_to_bin()
  end

  defp bxor(a, b), do: Bitwise.bxor(a, b)
end
