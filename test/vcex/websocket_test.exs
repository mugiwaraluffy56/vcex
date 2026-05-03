defmodule Vcex.WebSocketTest do
  use ExUnit.Case, async: true

  test "accept key matches RFC example" do
    assert Vcex.WebSocket.accept_key("dGhlIHNhbXBsZSBub25jZQ==") ==
             "s3pPLMBiTxaQ9kYGzzhZRbK+xOo="
  end

  test "encodes small text frames" do
    assert Vcex.WebSocket.encode_text("hi") == <<0x81, 2, "hi">>
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

    assert {:ok, 1, "hi", ""} = Vcex.WebSocket.decode_frame(frame)
  end

  test "keeps tail after one frame" do
    mask = <<1, 2, 3, 4>>
    payload = <<Bitwise.bxor(?h, 1), Bitwise.bxor(?i, 2)>>
    frame = <<1::1, 0::3, 1::4, 1::1, 2::7, mask::binary, payload::binary, "tail">>

    assert {:ok, 1, "hi", "tail"} = Vcex.WebSocket.decode_frame(frame)
  end

  test "waits for partial frame" do
    assert :more = Vcex.WebSocket.decode_frame(<<1::1, 0::3, 1::4, 1::1, 5::7, 1, 2, 3, 4, "hi">>)
  end
end
