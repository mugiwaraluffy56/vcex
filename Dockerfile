FROM hexpm/elixir:1.19.0-erlang-28.0.2-alpine-3.22.0

WORKDIR /app

ENV MIX_ENV=prod \
    PORT=4000

COPY mix.exs ./
COPY config ./config
COPY lib ./lib
COPY public ./public

RUN mix compile

EXPOSE 4000

CMD ["mix", "run", "--no-halt"]

