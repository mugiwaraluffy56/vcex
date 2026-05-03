defmodule LanCall.WebSocketTest do
  use ExUnit.Case, async: true

  test "accept key matches RFC example" do
    assert LanCall.WebSocket.accept_key("dGhlIHNhbXBsZSBub25jZQ==") ==
             "s3pPLMBiTxaQ9kYGzzhZRbK+xOo="
  end

  test "encodes small text frames" do
    assert LanCall.WebSocket.encode_text("hi") == <<0x81, 2, "hi">>
  end

  test "decodes masked browser text frame" do
    mask = <<1, 2, 3, 4>>
    mask_bytes = :binary.bin_to_list(mask)

    payload =
      "hi"
      |> :binary.bin_to_list()
      |> Enum.with_index()
      |> Enum.map(fn {byte, idx} -> Bitwise.bxor(byte, Enum.at(mask_bytes, rem(idx, 4))) end)
      |> :binary.list_to_bin()

    frame = <<1::1, 0::3, 1::4, 1::1, 2::7, mask::binary, payload::binary>>

    assert {:ok, 1, "hi"} = LanCall.WebSocket.decode(frame)
  end
end
