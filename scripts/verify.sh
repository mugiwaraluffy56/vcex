#!/usr/bin/env sh
set -eu

mix format --check-formatted
mix test
elixir smoke_test.exs

