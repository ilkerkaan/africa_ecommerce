FROM elixir:1.14-alpine

RUN apk update && \
    apk add --no-cache build-base nodejs npm git postgresql-client

WORKDIR /app

# Install hex, rebar, and phoenix
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new 1.7.7 --force

# Copy configuration files
COPY mix.exs mix.lock ./
COPY config config

# Install dependencies
RUN mix deps.get

# Copy assets directory
COPY assets assets

# Copy the rest of the application code
COPY priv priv
COPY lib lib
COPY test test

# Compile the application
RUN mix do compile

EXPOSE 4000

CMD ["mix", "phx.server"]
