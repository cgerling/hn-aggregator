FROM elixir:1.13.4-alpine AS build

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /opt/app/hn_aggregator

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

COPY mix.exs mix.lock ./
COPY config/config.exs config/${MIX_ENV}.exs config/runtime.exs ./config/
COPY lib lib
COPY rel rel

RUN mix do deps.get, deps.compile, compile, release

FROM alpine:3.16.2 AS application

RUN apk add --no-cache libgcc libstdc++ ncurses-libs openssl

ENV APP_DIR=/opt/app/hn_aggregator

WORKDIR $APP_DIR

RUN chown nobody:nobody $APP_DIR

USER nobody:nobody

COPY --from=build --chown=nobody:nobody $APP_DIR/_build/prod/rel/hn_aggregator ./

ENV HOME=$APP_DIR

CMD bin/hn_aggregator start
