.PHONY: test format smoke run desktop-info verify

test:
	mix test

format:
	mix format --check-formatted

smoke:
	elixir smoke_test.exs

run:
	mix run --no-halt

desktop-info:
	npm run desktop:info

verify: format test smoke

